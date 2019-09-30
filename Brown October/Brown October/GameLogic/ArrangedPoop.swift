//
//  Arranged.swift
//  Brown October
//
//  Created by Benjamin Lewis on 14/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class ArrangedPoop {
    private var offsetPoop: OffsetPoop
    private let board: Board

    lazy private var poop = offsetPoop.poop
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

        let direction = offsetPoop.direction
        board.setPoopStain(offsetPoop.poop, x: coordinate.x, y: coordinate.y, direction: direction)
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
            offsetPoop = offsetPoop.rotate() as! OffsetPoop
            guard offsetPoop.direction != poopStain.direction else {
                _ = place(at: (poopStain.x, poopStain.y))
                return false
            }
        } while !place(at: (poopStain.x, poopStain.y))

        return true
    }

    private func evaluate(x: Int, y: Int, closure: (Int) -> Bool) -> Bool {
        let xAdjusted = x + offsetPoop.xOffset()
        let yAdjusted = y + offsetPoop.yOffset()

        for (yIndex, values) in offsetPoop.data.enumerated() {
            for (xIndex, value) in values.enumerated() {
                guard value == 1 else { continue }
                guard let index = gridUtility.calcIndex(xAdjusted + xIndex, yAdjusted + yIndex) else { return false }
                guard closure(index) else { return false }
            }
        }

        return true
    }

    private func hasAdjacentPoop(at index: Int) -> Bool {
        guard board.game.gameRule == .russian else { return false }
        guard let (x, y) = gridUtility.calcXY(index) else { return false }

        for v in [-1, 0, 1] {
            for h in [-1, 0, 1] {
                guard let adjustedIndex = gridUtility.calcIndex(x + h, y + v) else { continue }

                if board.tile(at: adjustedIndex).poopIdentifier > 0 { return true }
            }
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

    init(_ offsetPoop: OffsetPoop, _ board: Board) {
        self.offsetPoop = offsetPoop
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

        self.offsetPoop = OffsetPoop.make(poop, direction: poopDirection)
        self.board = board
    }
}
