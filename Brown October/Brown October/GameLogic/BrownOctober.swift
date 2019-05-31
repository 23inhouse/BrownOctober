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
    var playerOne = Player.computer
    var playerTwo = Player.human

    func over() -> Bool {
        return playerOne.won() || playerTwo.won()
    }
}

class Player {
    static let human = Player("human")
    static let computer = Player("computer")
    var board: Board
    let isHuman: Bool
    let isComputer: Bool

    func won() -> Bool {
        return board.flushedAllPoops()
    }

    init(_ name: String) {
        self.isHuman = name == "human"
        self.isComputer = !isHuman

        self.board = Board(width: Board.size, height: Board.size, poops: Poop.pinchSomeOff())
        board.placePoopsRandomly()
    }
}

class Board: Grid {
    typealias PoopStain = (x: Int, y: Int, direction: Int)

    static let size = 10

    var score = 0
    var poops: [Poop]
    var poopStains = [Int: PoopStain]()

    func placePoopsRandomly() {
        tiles = cleanTiles()
        poops = Poop.pinchSomeOff()

        let utility = gridUtility

        for poop in poops.reversed() {
            while true {
                let x = Int(arc4random_uniform(UInt32(utility.width)))
                let y = Int(arc4random_uniform(UInt32(utility.height)))
                let direction = Int(arc4random_uniform(4))

                if placePoop(poop, x: x, y: y, direction: direction, tiles: &tiles) {
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
            _ = placePoop(poop, x: value.x, y: value.y, direction: value.direction, tiles: &tiles)
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

    func placePoop(_ poop: Poop, x:Int, y:Int, direction:Int, tiles: inout [Tile], check: Bool = true) -> Bool {

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
            return placePoop(poop, x: x, y: y, direction: direction, tiles: &tiles, check: false)
        }

        return true
    }

    func removePoop(_ poop: Poop, x:Int, y:Int, direction:Int, tiles: inout [Tile]) -> Bool {

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
