//
//  Brown October.swift
//  Brown October
//
//  Created by Benjamin Lewis on 18/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation


class BrownOctober: Game {

}

class Game {
    lazy var playerOne = Player.computer()
    lazy var playerTwo = Player.human()

    func over() -> Bool {
        return playerOne.won() || playerTwo.won()
    }
}

class Player {
    enum key {
        case human
        case computer
    }

    let key: Player.key
    var board: Board
    let isHuman: Bool
    let isComputer: Bool

    static func human() -> Player {
        return Player(Player.key.human)
    }

    static func computer() -> Player {
        return Player(Player.key.computer)
    }

    func won() -> Bool {
        return board.flushedAllPoops()
    }

    init(_ key: Player.key) {
        self.key = key
        self.isHuman = key == Player.key.human
        self.isComputer = !isHuman

        self.board = Board.makeGameBoard()
        board.placePoopsRandomly()
    }
}

class Board: Grid {
    typealias PoopStain = (x: Int, y: Int, direction: Direction)

    static let size = 10

    var score = 0
    var poops: [Poop]
    var poopStains = [Int: PoopStain]()

    static func makeGameBoard() -> Board {
        return Board(width: size, height: size, poops: Poop.pinchSomeOff())
    }

    func placePoopsRandomly() {
        tiles = cleanTiles()
        poops = Poop.pinchSomeOff()

        let utility = gridUtility

        for poop in poops.reversed() {
            while true {
                let x = Int(arc4random_uniform(UInt32(utility.width)))
                let y = Int(arc4random_uniform(UInt32(utility.height)))
                let direction = Int(arc4random_uniform(4))

                if place(poop: poop, x: x, y: y, direction: direction) { break }
            }
        }
    }

    func placePoopStains() {
        tiles = cleanTiles()
        poops = Poop.pinchSomeOff()

        for (ident, poopStain) in poopStains {
            let poop = poops[ident - 1]
            _ = place(poop: poop, x: poopStain.x, y: poopStain.y, direction: poopStain.direction.value)
        }
    }

    func flushedAllPoops() -> Bool {
        for poop in poops {
            if !poop.isFound {
                return false
            }
        }

        return true
    }

    func biggestPoop() -> Int? {
        let size = poops.filter { !$0.isFound }.map { $0.poopSize }.max()
        return size
    }

    func wipe(at index: Int) -> (Tile, Poop)? {
        if let (tile, poop) = findData(at: index) {
            guard !tile.isFound else {
                return nil
            }
            score += 1
            tile.markAsFound()
            poop.incrementFoundCounter()

            return (tile, poop)
        }

        return nil
    }

    func place(poop: Poop, x: Int, y: Int, direction: Int, check: Bool = true) -> Bool {
        let placeable = checkPoop(poop: poop, x: x, y: y, direction: direction, closure: { (index) in
            if check == true {
                guard tiles[index].poopIdentifier < 1 || tiles[index].poopIdentifier == poop.identifier else { return false }
                if isAPoop(nextTo: index) { return false }
                return true
            }

            tiles[index].poopIdentifier = poop.identifier
            return true
        })

        guard placeable else { return false }

        if check == true {
            return place(poop: poop, x: x, y: y, direction: direction, check: false)
        }

        poopStains[poop.identifier] = Board.PoopStain(x: x, y: y, direction: Direction(direction))
        return true
    }

    func rotate(poop: Poop) -> Bool {
        let poopStain = poopStains[poop.identifier]!

        let removedPoop = remove(poop: poop)
        guard removedPoop else { return false }

        var rotatedPoop:RotatableProtocol = DirectedPoop.make(poop, direction: poopStain.direction) as! RotatableProtocol
        repeat {
            rotatedPoop = rotatedPoop.rotate()
            guard rotatedPoop.direction != poopStain.direction else {
                print("Error: couldn't place poop")
                _ = place(poop: poop, x: poopStain.x, y: poopStain.y, direction: poopStain.direction.value)
                return false
            }
        } while !place(poop: poop, x: poopStain.x, y: poopStain.y, direction: rotatedPoop.direction.value)

        return true
    }

    func move(poop: Poop, to index: Int) -> Bool {
        let poopStain = poopStains[poop.identifier]!

        guard let (x, y) = gridUtility.calcXY(index) else { return false }

        let removedPoop = remove(poop: poop)
        guard removedPoop else { return false }
        guard place(poop: poop, x: x, y: y, direction: poopStain.direction.value) else {
            _ = place(poop: poop, x: poopStain.x, y: poopStain.y, direction: poopStain.direction.value)
            return false
        }

        return true
    }

    func move(poop: Poop, by adjustment: (Int, Int)) -> Bool {
        let poopStain = poopStains[poop.identifier]!

        let (xAdjust, yAdjust) = adjustment

        let x = poopStain.x + xAdjust
        let y = poopStain.y + yAdjust

        let removedPoop = remove(poop: poop)
        guard removedPoop else { return false }
        guard place(poop: poop, x: x, y: y, direction: poopStain.direction.value) else {
            _ = place(poop: poop, x: poopStain.x, y: poopStain.y, direction: poopStain.direction.value)
            return false
        }

        return true
    }

    private func remove(poop: Poop) -> Bool {
        let poopStain = poopStains[poop.identifier]!

        return checkPoop(poop: poop, x: poopStain.x, y: poopStain.y, direction: poopStain.direction.value) { (index) in
            tiles[index].poopIdentifier = 0
            return true
        }
    }

    private func checkPoop(poop: Poop, x: Int, y: Int, direction: Int, closure: (Int) -> Bool) -> Bool {
        let directedPoop = DirectedPoop.make(poop, direction: direction)

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

    private func isAPoop(nextTo index: Int) -> Bool {
        if allowAdjacentPoops { return false }

        for direction in Direction.all() {
            guard let adjustedIndex = gridUtility.adjustIndex(index, direction: direction, offset: 1) else {
                continue
            }

            if tiles[adjustedIndex].poopIdentifier > 0 { return true }
        }

        return false
    }

    private func findData(at index: Int) -> (Tile, Poop)? {
        let tile = tiles[index]
        let indent = tile.poopIdentifier

        guard indent != 0 else { return nil }

        for poop in self.poops {
            if poop.identifier == indent {
                return (tile, poop)
            }
        }

        return nil
    }

    init(width: Int, height: Int, poops: [Poop] = [Poop]()) {
        self.poops = poops

        super.init(width: width, height: height)
    }
}

class Grid {
    let allowAdjacentPoops = true

    let gridUtility: GridUtility
    lazy var tiles: [Tile] = self.cleanTiles()

    func numberOfFoundTiles() -> Int {
        return tiles.filter({ $0.isFound }).count
    }

    func numberOfFlushedTiles() -> Int {
        return tiles.filter({ $0.isFlushed }).count
    }

    func cleanTiles() -> [Tile] {
        var tiles = [Tile]()
        for y in 0 ..< gridUtility.height {
            for x in 0 ..< gridUtility.width {
                let tile = Tile(x: x, y: y, poopIdent: 0)
                tiles.append(tile)
            }
        }
        return tiles
    }

    func currentState() -> [Int?] {
        var values = [Int?]()

        for tile in self.tiles {
            let value: Int?
            if tile.isFlushed {
                value = nil
            } else if tile.isFound {
                value = 1
            } else {
                value = 0
            }
            values.append(value)
        }

        return values
    }

    init(width: Int, height: Int) {
        self.gridUtility = GridUtility.init(w: width, h: height)
    }
}
