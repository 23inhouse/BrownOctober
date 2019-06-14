//
//  Arranged.swift
//  Brown October
//
//  Created by Benjamin Lewis on 14/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class ArrangedPoop {
    private var directedPoop: DirectedPoop
    private let board: Board

    lazy private var poop = directedPoop.poop
    lazy private var gridUtility = board.gridUtility

    func move(by adjustment: (Int, Int)) -> Bool {
        let poopStain = board.poopStains[poop.identifier]!

        let (xAdjust, yAdjust) = adjustment
        let x = poopStain.x + xAdjust
        let y = poopStain.y + yAdjust

        guard remove() else { return false }
        guard place(at: (x, y)) else {
            _ = place(at: (poopStain.x, poopStain.y))
            return false
        }

        return true
    }

    func move(to index: Int) -> Bool {
        let poopStain = board.poopStains[poop.identifier]!

        guard remove() else { return false }
        guard place(at: index) else {
            _ = place(at: (poopStain.x, poopStain.y))
            return false
        }

        return true
    }

    func place(at coordinate: (x: Int, y: Int), check: Bool = true) -> Bool {
        let placeable = evaluate(x: coordinate.x, y: coordinate.y, closure: { (index) in
            if check == true {
                guard board.tile(at: index).poopIdentifier < 1 || board.tile(at: index).poopIdentifier == poop.identifier else { return false }
                if hasAdjacentPoop(at: index) { return false }
                return true
            }

            board.tile(at: index).set(identifier: poop.identifier)
            return true
        })

        guard placeable else { return false }

        if check == true {
            return place(at: coordinate, check: false)
        }

        board.addPoopStain(directedPoop.poop, x: coordinate.x, y: coordinate.y, direction: directedPoop.direction)
        return true
    }

    func place(at index: Int, check: Bool = true) -> Bool {
        guard let (x, y) = gridUtility.calcXY(index) else { return false }
        return place(at: (x, y), check: check)
    }

    func rotate() -> Bool {
        let poopStain = board.poopStains[poop.identifier]!

        guard remove() else { return false }

        repeat {
            let rotatablePoop = (directedPoop as! RotatableProtocol).rotate()
            directedPoop = rotatablePoop as! DirectedPoop
            guard directedPoop.direction != poopStain.direction else {
                _ = place(at: (poopStain.x, poopStain.y))
                return false
            }
        } while !place(at: (poopStain.x, poopStain.y))

        return true
    }

    private func evaluate(x: Int, y: Int, closure: (Int) -> Bool) -> Bool {
        let xAdjusted = x - directedPoop.centerOffset + directedPoop.offset.x
        let yAdjusted = y - directedPoop.centerOffset + directedPoop.offset.y

        for (yIndex, values) in directedPoop.data.enumerated() {
            for (xIndex, value) in values.enumerated() {
                guard value == 1 else { continue }
                guard let index = gridUtility.calcIndex(xAdjusted + xIndex, yAdjusted + yIndex) else { return false }
                guard closure(index) else { return false }
            }
        }

        return true
    }

    private func hasAdjacentPoop(at index: Int) -> Bool {
        if board.allowAdjacentPoops { return false }

        for direction in Direction.all() {
            guard let adjustedIndex = gridUtility.adjustIndex(index, direction: direction, offset: 1) else {
                continue
            }

            if board.tile(at: adjustedIndex).poopIdentifier > 0 { return true }
        }

        return false
    }

    private func remove() -> Bool {
        let poopStain = board.poopStains[poop.identifier]!

        return evaluate(x: poopStain.x, y: poopStain.y) { (index) in
            board.tile(at: index).set(identifier: 0)
            return true
        }
    }

    init(_ directedPoop: DirectedPoop, _ board: Board) {
        self.directedPoop = directedPoop
        self.board = board
    }

    init?(_ poop: Poop, _ board: Board, direction: Direction? = nil) {
        var poopDirection: Direction

        if let poopStain = board.poopStains[poop.identifier] {
            poopDirection = poopStain.direction
        } else if let direction = direction {
            poopDirection = direction
        } else {
            return nil
        }

        self.directedPoop = DirectedPoop.make(poop, direction: poopDirection)
        self.board = board
    }
}
