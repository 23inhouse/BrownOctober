//
//  Brown October.swift
//  Brown October
//
//  Created by Benjamin Lewis on 18/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class BrownOctober: Game {
    static func calcMaxGuesses(difficultyLevel: Int = 1) -> Int {
        let zeroDifficulty = 56
        let delta = 8
        return zeroDifficulty - (difficultyLevel * delta)
    }

    func arrangeBoards(playMode: PlayMode, poopStains: [Int: Board.PoopStain]) {
        switch playMode {
        case .wholeBoard:
            player.board.arrangePoops()
            computerPlayer.board.copy(from: player.board)
        case .alternating:
            player.board.arrangePoops()
            computerPlayer.board.set(poopStains: poopStains)
            computerPlayer.board.arrangePoops()
        }

    }

    init(difficultyLevel: Int) {
        let maxGuessesAllowed = BrownOctober.calcMaxGuesses(difficultyLevel: difficultyLevel)
        super.init(maxAllowedMisses: maxGuessesAllowed)
    }
}

class Game {
    lazy private(set) var computerPlayer = Player.computer(game: self)
    lazy private(set) var player = Player.human(game: self)

    let maxAllowedMisses: Int

    func over() -> Bool {
        return player.isGameOver && computerPlayer.isGameOver
    }

    func winner() -> Player? {
        if player.won() && computerPlayer.lost() {
            return player
        } else if player.lost() && computerPlayer.won() {
            return computerPlayer
        }

        if player.board.score > computerPlayer.board.score {
            return player
        } else if computerPlayer.board.score > player.board.score {
            return computerPlayer
        }

        if player.board.guesses < computerPlayer.board.guesses {
            return player
        } else if computerPlayer.board.guesses < player.board.guesses {
            return computerPlayer
        }

        return nil
    }

    init(maxAllowedMisses: Int = 100) {
        self.maxAllowedMisses = maxAllowedMisses
    }
}

class Player {
    enum Key {
        case human
        case computer
    }

    let key: Player.Key
    let game: Game
    let board: Board
    let foundPoopsBoard: Board
    let isHuman: Bool
    let isComputer: Bool

    var isGameOver: Bool {
        return won() || lost()
    }

    static func human(game: Game = Game()) -> Player {
        return Player(Player.Key.human, game: game)
    }

    static func computer(game: Game = Game()) -> Player {
        return Player(Player.Key.computer, game: game)
    }

    func lost() -> Bool {
        return board.misses >= game.maxAllowedMisses
    }

    func won() -> Bool {
        return board.flushedAllPoops()
    }

    init(_ key: Player.Key, game: Game = Game()) {
        self.key = key
        self.isHuman = key == Player.Key.human
        self.isComputer = !isHuman

        self.game = game

        self.board = Board.makeGameBoard()
        self.board.game = game
        self.foundPoopsBoard = Board.makeFoundPoopsBoard()
    }
}

class Board: Grid {
    typealias PoopStain = (x: Int, y: Int, direction: Direction)

    static let size = 10
    static let foundPoopsSize = 7

    var game: Game = Game()
    var guesses = 0
    var misses: Int {
        return guesses - score
    }
    private(set) var score = 0
    private(set) var poops: [Poop]
    private(set) var poopStains = [Int: PoopStain]()

    private(set) lazy var count = gridUtility.count

    static func makeGameBoard() -> Board {
        return Board(width: size, height: size, poops: Poop.pinchSomeOff())
    }

    static func makeFoundPoopsBoard() -> Board {
        return Board(width: foundPoopsSize, height: foundPoopsSize, poops: Poop.pinchSomeOff())
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

    func arrangeFoundPoops() {
        cleanTiles()

        _ = ArrangedPoop(poops[0], self, direction: Direction(0))?.place(at: (6, 1), check: false)
        _ = ArrangedPoop(poops[1], self, direction: Direction(0))?.place(at: (5, 2), check: false)
        _ = ArrangedPoop(poops[2], self, direction: Direction(3))?.place(at: (1, 4), check: false)
        _ = ArrangedPoop(poops[3], self, direction: Direction(0))?.place(at: (5, 5), check: false)
        _ = ArrangedPoop(poops[4], self, direction: Direction(0))?.place(at: (4, 6), check: false)
        _ = ArrangedPoop(poops[5], self, direction: Direction(0))?.place(at: (2, 1), check: false)
    }

    func findAdjacentPoop(from index: Int) -> [Direction] {
        let poopIdentifier = tile(at: index).poopIdentifier

        var directions = [Direction]()

        for direction in Direction.order {
            guard poopIdentifier > 0 else { continue }

            let direction = Direction(direction)
            guard let adjacentIndex = gridUtility.adjust(index: index, direction: direction, offset: 1) else { continue }

            let adjacentTile = tile(at: adjacentIndex)
            guard adjacentTile.poopIdentifier == poopIdentifier else { continue }

            directions.append(direction)
        }

        return directions
    }

    func flush(by poopIdentifier: Int) {
        for index in tileIndexes(for: poopIdentifier) {
            tile(at: index).markAsFlushed()
        }

    }

    func flushedAllPoops() -> Bool {
        for poop in poops where !poop.isFound {
            return false
        }

        return true
    }

    func biggestPoop() -> Int? {
        let size = poops.filter { !$0.isFound }.map { $0.poopSize }.max()
        return size
    }

    func copy(from other: Board) {
        for i in 0 ..< gridUtility.count {
            let poopIdentifier = other.tile(at: i).poopIdentifier
            tiles[i].set(identifier: poopIdentifier)
        }
    }

    func wipe(at index: Int) -> Poop? {
        let tileToWipe = tile(at: index)
        guard !tileToWipe.isFound else { return nil }

        guesses += 1

        guard let poop = findPoop(by: tileToWipe.poopIdentifier) else {
            tileToWipe.markAsFlushed()
            return nil
        }

        tileToWipe.markAsFound()
        score += 1
        poop.incrementFoundCounter()

        if poop.isFound {
            flush(by: poop.identifier)
        }

        return poop
    }

    func firstIncompletePoopIndex() -> Int? {
        return tiles.firstIndex { tile in tile.isFound && !tile.isFlushed }
    }

    func poop(at index: Int) -> Poop? {
        let poopIdent = tile(at: index).poopIdentifier
        guard poopIdent > 0 else { return nil }

        return poops[poopIdent - 1]

    }

    func tileIndexes(for poopIndentifier: Int) -> [Int] {
        return tiles.enumerated().filter({ _, tile in tile.poopIdentifier == poopIndentifier }).map { index, _ in index }
    }

    private func findPoop(by ident: Int) -> Poop? {
        for poop in self.poops where poop.identifier == ident {
            return poop
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
