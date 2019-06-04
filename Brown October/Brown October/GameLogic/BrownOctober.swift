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

        self.board = Board.buildGameBoard()
        board.placePoopsRandomly()
    }
}

class Board: Grid {
    typealias PoopStain = (x: Int, y: Int, direction: Int)

    static let size = 10

    var score = 0
    var poops: [Poop]
    var poopStains = [Int: PoopStain]()

    static func buildGameBoard() -> Board {
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

                if place(poop: poop, x: x, y: y, direction: direction, tiles: &tiles) {
                    poopStains[poop.identifier] = PoopStain(x: x, y: y, direction: direction)
                    break
                }
            }
        }
    }

    func placePoopStains() {
        tiles = cleanTiles()
        poops = Poop.pinchSomeOff()

        for poopStain in poopStains {
            let poop = poops[poopStain.key - 1]
            let value = poopStain.value
            _ = place(poop: poop, x: value.x, y: value.y, direction: value.direction, tiles: &tiles)
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

    func biggestPoop() -> Int {
        let size = poops.filter { !$0.isFound}.map { $0.poopSize }.max()
        return size ?? 0
    }

    func wipe(at index: Int) -> (Tile, Poop)? {
        if let (tile, poop) = findData(tiles: &self.tiles, at: index) {
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

    func rotate(poop: Poop) -> Bool {
        guard let poopStain = poopStains[poop.identifier] else { return false }

        let removedPoop = remove(poop: poop, x: poopStain.x, y: poopStain.y, direction: poopStain.direction, tiles: &tiles)
        guard removedPoop else { return false }

        var direction = poopStain.direction + 1
        if direction > 3 { direction = 0 }
        while !place(poop: poop, x: poopStain.x, y: poopStain.y, direction: direction, tiles: &tiles) {
            guard direction != poopStain.direction else {
                print("Error: couldn't place poop")
                _ = place(poop: poop, x: poopStain.x, y: poopStain.y, direction: poopStain.direction, tiles: &tiles)
                break
            }
            direction += 1
            if direction > 3 { direction = 0 }
        }
        poopStains[poop.identifier]!.direction = direction

        return true
    }

    func move(poop: Poop, by adjustment: Int) -> Bool {
        let poopStain = poopStains[poop.identifier]!

        guard let index = gridUtility.calcIndex(poopStain.x, poopStain.y) else { return false }
        guard let (x, y) = gridUtility.calcXY(index + adjustment) else { return false }

        let removedPoop = remove(poop: poop, x: poopStain.x, y: poopStain.y, direction: poopStain.direction, tiles: &tiles)
        guard removedPoop else { return false }
        guard place(poop: poop, x: x, y: y, direction: poopStain.direction, tiles: &tiles) else {
            _ = place(poop: poop, x: poopStain.x, y: poopStain.y, direction: poopStain.direction, tiles: &tiles)
            return false
        }

        poopStains[poop.identifier] = Board.PoopStain(x: x, y: y, direction: poopStain.direction)
        return true
    }

    private func findData(tiles: inout [Tile], at index: Int) -> (Tile, Poop)? {

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

    func place(poop: Poop, x:Int, y:Int, direction:Int, tiles: inout [Tile], check: Bool = true) -> Bool {

        let data = GridUtility.rotate(poop.data, times: direction)

        for (yIndex, values) in data.enumerated() {
            for (xIndex, value) in values.enumerated() {

                guard value == 1 else { continue }

                guard let (xAdjust, yAdjust) = GridUtility.rotateXY(xIndex, yIndex, direction) else {
                    return false
                }

                guard let index = gridUtility.calcIndex(x + xAdjust, y + yAdjust) else {
                    return false
                }

                if check == true {
                    guard tiles[index].poopIdentifier < 1 || tiles[index].poopIdentifier == poop.identifier else { return false }
                    if poops(nextTo: index) { return false }
                    continue
                }

                tiles[index].poopIdentifier = poop.identifier
            }
        }

        if check == true {
            return place(poop: poop, x: x, y: y, direction: direction, tiles: &tiles, check: false)
        }

        return true
    }

    func remove(poop: Poop, x:Int, y:Int, direction:Int, tiles: inout [Tile]) -> Bool {

        let data = GridUtility.rotate(poop.data, times: direction)

        for (yIndex, values) in data.enumerated() {
            for (xIndex, value) in values.enumerated() {

                guard value == 1 else { continue }

                guard let (xAdjust, yAdjust) = GridUtility.rotateXY(xIndex, yIndex, direction) else {
                    return false
                }

                guard let index = gridUtility.calcIndex(x + xAdjust, y + yAdjust) else {
                    return false
                }

                tiles[index].poopIdentifier = 0
            }
        }

        return true
    }

    func flushed(nextTo index: Int) -> Bool {
        for direction in 0 ..< 4 {
            guard let adjustedIndex = gridUtility.adjustIndex(index, direction: direction, offset: 1) else {
                continue
            }

            if tiles[adjustedIndex].isFlushed { return true }
        }

        return false
    }

    private func poops(nextTo index: Int) -> Bool {
        if allowAdjacentPoops { return false }

        for direction in 0 ..< 4 {
            guard let adjustedIndex = gridUtility.adjustIndex(index, direction: direction, offset: 1) else {
                continue
            }

            if tiles[adjustedIndex].poopIdentifier > 0 { return true }
        }

        return false
    }

    init(width: Int, height: Int) {
        self.gridUtility = GridUtility.init(w: width, h: height)
    }
}
