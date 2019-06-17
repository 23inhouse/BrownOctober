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
    lazy private(set) var playerOne = Player.computer()
    lazy private(set) var playerTwo = Player.human()

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
    let board: Board
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
    }
}

class Board: Grid {
    typealias PoopStain = (x: Int, y: Int, direction: Direction)

    static let size = 10

    private(set) var score = 0
    private(set) var poops: [Poop]
    private(set) var poopStains = [Int: PoopStain]()

    private(set) lazy var count = gridUtility.count

    static func makeGameBoard() -> Board {
        return Board(width: size, height: size, poops: Poop.pinchSomeOff())
    }

    func set(poops: [Poop]) {
        self.poops = poops
    }

    func set(poopStains: [Int: PoopStain]) {
        self.poopStains = poopStains
    }

    func setPoopStain(_ poop: Poop, x: Int, y: Int, direction: Direction) {
        poopStains[poop.identifier] = Board.PoopStain(x: x, y: y, direction: direction)
    }

    func arrangePoops(reset: Bool = false) {
        cleanTiles()

        if reset { poopStains.removeAll() }

        for poop in poops.reversed() {
            guard let poopStain = poopStains[poop.identifier] else {
                placeRandomly(poop)
                continue
            }

            let offsetPoop = OffsetPoop(poop, direction: poopStain.direction)
            guard ArrangedPoop(offsetPoop, self).place(at: (poopStain.x, poopStain.y)) else {
                placeRandomly(poop)
                continue
            }
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

    func firstIncompletePoopIndex() -> Int? {
        return tiles.firstIndex { tile in tile.isFound && !tile.isFlushed }
    }

    func tileIndexes(for poopIndentifier: Int) ->[Int] {
        return tiles.enumerated().filter({ _, tile in tile.poopIdentifier == poopIndentifier }).map { index, _ in index }
    }

    private func findData(at index: Int) -> (Tile, Poop)? {
        let foundTile = tile(at: index)
        let indent = foundTile.poopIdentifier

        guard indent != 0 else { return nil }

        for poop in self.poops {
            if poop.identifier == indent {
                return (foundTile, poop)
            }
        }

        return nil
    }

    private func placeRandomly(_ poop: Poop) {
        while true {
            let index = Int.random(in: 0 ... count)
            let offsetPoop = OffsetPoop.makeRandom(poop)

            if ArrangedPoop(offsetPoop, self).place(at: index) { break }
        }
    }

    init(width: Int, height: Int, poops: [Poop] = [Poop]()) {
        self.poops = poops

        super.init(width: width, height: height)
    }
}

class Grid {
    let gridUtility: GridUtility
    let allowAdjacentPoops = true

    fileprivate var tiles = [Tile]()

    func cleanTiles() {
        self.tiles = Array(0 ..< gridUtility.count).map { _ in Tile() }
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

    func numberOfFlushedTiles() -> Int {
        return tiles.filter({ $0.isFlushed }).count
    }

    func numberOfFoundTiles() -> Int {
        return tiles.filter({ $0.isFound }).count
    }

    func print() {
        for y in 0 ..< gridUtility.height {
            let index = y * gridUtility.width
            let row = tiles[index ..< (index + gridUtility.width)]
            Swift.print(row.map { $0.poopIdentifier })
        }
    }

    func tile(at index: Int) -> Tile {
        return tiles[index]
    }

    init(width: Int, height: Int) {
        self.gridUtility = GridUtility.init(w: width, h: height)
        cleanTiles()
    }
}
