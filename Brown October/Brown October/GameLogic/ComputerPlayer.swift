//
//  computerPlayer.swift
//  Brown October
//
//  Created by Benjamin Lewis on 23/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

typealias NextGuessClosure = (_ instance: Guesser, @escaping () -> Void) -> ()

class Guesser {

    let closure: NextGuessClosure
    var nextGuessQueue = [(() -> Void)]()

    static func callNow(_ instance: Guesser, closure: @escaping () -> Void) {
        closure()
    }

    static func callLater(_ instance: Guesser, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: { closure() })
    }

    static func callFromQueueNow(_ instance: Guesser, closure: @escaping () -> Void) {
        instance.nextGuessQueue.append(closure)
    }

    func perform(nextTurn: @escaping () -> Void) {
        closure(self) {
            nextTurn()
        }
    }

    func nextTurnFromQueue() -> (() -> Void)? {
        return nextGuessQueue.popLast()
    }

    init(nextGuessClosure: NextGuessClosure? = nil) {
        self.closure = nextGuessClosure ?? Guesser.callNow
    }
}

class ComputerPlayer {

    static let debug = false
    static let searchEfficiency: Double = 1

    let board: Board

    fileprivate let boardViewProtocol: TouchableBoard
    fileprivate let gridUtility: GridUtility
    fileprivate let maxGuesses = 100
    fileprivate let guesser: Guesser
    fileprivate var guesses = [Int]()

    lazy var poopSeeker = PoopSeeker(player: self)

    func play(startAt: Int? = nil) {
        huntForBrownOctober(startAt)
    }

    func playNext() {
        guard let closure = guesser.nextTurnFromQueue() else {
            play()
            return
        }

        closure()
    }

    func guessCount() -> Int {
        return guesses.count
    }

    private func makeGuess(_ index: Int) -> Bool {

        let previousScore = self.board.score

        let button = boardViewProtocol.getButton(at: index)
        button.touch()

        if self.board.score == previousScore {
            if ComputerPlayer.debug, let (x, y) = gridUtility.calcXY(index) {
                print("[\(guessCount())] Missed! at (\(x), \(y))")
            }
            return false
        }

        let poopIdentifier = self.board.tile(at: index).poopIdentifier
        if ComputerPlayer.debug, let (x, y) = gridUtility.calcXY(index) {
            print("[\(guessCount())] Hit! #\(poopIdentifier) at (\(x), \(y))")
        }
        if ComputerPlayer.debug, self.board.poops[poopIdentifier - 1].isFound {
            print("[\(guessCount())] Found! #\(poopIdentifier)")
        }

        return true
    }

    private func huntForBrownOctober(_ guessIndex: Int?) {

        guard !board.flushedAllPoops() && guessCount() < maxGuesses else { return }

        poopSeeker = PoopSeeker(player: self)

        let (newGuessIndex, incompletePoopIndex) = newUnusedGuess(guessIndex)

        if incompletePoopIndex != nil {
            let hottestIndex = poopSeeker.heatSeek(around: incompletePoopIndex!)
            self.huntForBrownOctober(hottestIndex)
            return
        }

        guard let index = newGuessIndex else {
            print("\nError: Serious problems couldn't get a new guess index\n\n\n")
            return
        }

        if ComputerPlayer.debug, let (x, y) = gridUtility.calcXY(index) {
            print("[\(guessCount())] Hunting at (\(x), \(y))")
        }

        if self.makeGuess(index) {
            if self.board.flushedAllPoops() { return }

            let poopIdent = self.board.tile(at: index).poopIdentifier

            let poop = self.board.poops[poopIdent - 1]
            if poop.isFound {
                guesser.perform { [weak self] in self?.huntForBrownOctober(nil) }
                return
            }

            guesser.perform { [weak self] in
                guard let self = self else { return }
                let hottestIndex = self.poopSeeker.heatSeek(around: index)
                self.huntForBrownOctober(hottestIndex)
            }
            return
        }

        guesser.perform { [weak self] in self?.huntForBrownOctober(nil) }
        return
    }

    private func newUnusedGuess(_ index: Int?) -> (Int?, Int?) {
        if index == nil {
            if let incompleteIndex = board.firstIncompletePoopIndex() {
                if ComputerPlayer.debug, let (x, y) = gridUtility.calcXY(incompleteIndex) {
                    print("Continuing from incomplete poop at (\(x), \(y))")
                }
                return (nil, incompleteIndex)
            }
        }

        if index != nil {

            guard guesses.contains(index!) else {
                guesses.append(index!)
                return (index!, nil)
            }

            return (nil, nil)
        }

        guard var guess = randomGuessIndex() else { return (nil, nil) }
        while guesses.contains(guess) {
            guard let nextGuess = randomGuessIndex() else { return (nil, nil) }
            guess = nextGuess
        }
        guesses.append(guess)

        return (guess, nil)
    }

    private func randomGuessIndex() -> Int? {
        guard let guess = poopSeeker.calcRandomBestIndex() else {
            print("Error no more random guesses from heatmap")
            return nil
        }

        return guess
    }

    init(board: Board, boardViewProtocol: TouchableBoard, guesser: Guesser? = nil) {
        self.board = board
        self.boardViewProtocol = boardViewProtocol
        self.gridUtility = board.gridUtility
        self.guesser = guesser ?? Guesser()
    }
}

class PoopSeeker {
    let gridUtility: GridUtility
    let board: Board
    let heatMap = Matrix()

    func heatSeek(around index: Int) -> Int? {

        if ComputerPlayer.debug, let (x, y) = gridUtility.calcXY(index) {
            print("[Seaker] Hunt around (\(x), \(y))")
        }

        return calcRandomBestIndex(at: index)
    }

    func calcRandomBestIndex(at index: Int? = nil) -> Int? {

        guard let bestGuesses = calcHeatMaps(at: index ?? 0) else {
            print("Error no more best guesses from heatmap")
            return nil
        }

        heatMap.width = self.gridUtility.width
        heatMap.height = self.gridUtility.height
        heatMap.data = bestGuesses

        let highests = bestGuesses.filter({ $0 != nil }).sorted(by: {$0! > $1!})
        let highest = highests.first!

        let minimumHeat: Double? = ComputerPlayer.searchEfficiency * Double(highest!)

        var bestIndexes = [Int]()
        for (i, v) in bestGuesses.enumerated() {
            guard let heatValue = v else { continue }

            board.tile(at: i).set(heat: Double(heatValue) / Double(highest!))
            guard Int(heatValue) >= Int(ceil(minimumHeat!)) else { continue }
            bestIndexes.append(i)
        }

        return bestIndexes[Int(arc4random_uniform(UInt32(bestIndexes.count)))]
    }

    func calcHeatMaps(at index: Int) -> [Int?]? {
        let size = [gridUtility.width, gridUtility.height].max()!

        let values = board.currentState()
        guard let matrix = board.gridUtility.captureGrid(values, at: index, size: size) else {
            print("Error: Invalid matrix")
            return nil
        }

        let heatMap = prepareHeatMap(matrix)
        let mustMatch = calcMatchSize(data: matrix.data)

        for n in Array(0 ... mustMatch).reversed() {
            let data = calcHeatMap(from: matrix, to: heatMap, mustMatch: n)
            if self.findHottestIndex(data: data) != nil {
                if ComputerPlayer.debug {
                    print("[Seaker] Must match = \(n)")
                    heatMap.data = data
                    heatMap.print("[Seaker] ---- HEAT MAP ----")
                }
                return data
            }
        }

        return nil
    }

    private func calcHeatMap(from matrix: Matrix, to heatMap: Matrix, mustMatch: Int) -> [Int?] {
        for poop in board.poops {
            if poop.isFound { continue }

            for direction in Direction.all() {
                let offsetPoop = OffsetPoop.init(poop, direction: direction)
                let poopData = offsetPoop.data

                let emptyPoopDataOffset = calcEmptyPoopOffset()
                for yMat in Array(emptyPoopDataOffset ..< matrix.height) {
                    for xMat in Array(emptyPoopDataOffset ..< matrix.width) {

                        if checkPlacement(grid: matrix.data, x: xMat, y: yMat, data: poopData, direction: direction.value, mustMatch: mustMatch) {
//                            print("[Seaker] It fits at (\(xMat),\(yMat)) going (\(direction))")
                            warmUpPoop(heatMap: heatMap, x: xMat, y: yMat, data: poopData, direction: direction.value)
                        }
                    }
                }
            }
        }

        return heatMap.data
    }

    private func calcMatchSize(data: [Int?]) -> Int {
        var size = 0

        for value in data { if value == 1 { size += 1 } }
        let max = (board.biggestPoop() ?? 1) - 1
        if size > max { size = max }

        return size
    }

    private func findHottestIndex(data: [Int?]) -> Int? {
        var index: Int = 0

        for (i, value) in data.enumerated() {
            guard value != nil else { continue }
            guard data[index] != nil else {
                index = i
                continue
            }

            if value! > data[index]! {
                index = i
            }
        }

        guard data[index]! > 0 else { return nil }

        return index
    }

    private func prepareHeatMap(_ matrix: Matrix) -> Matrix {
        let newMatrix = Matrix()
        newMatrix.width = matrix.width
        newMatrix.height = matrix.height
        newMatrix.data = matrix.data

        // remove poop tiles from heatmap
        for (i, value) in newMatrix.data.enumerated() {
            if value == 1 { newMatrix.data[i] = nil }
        }

        return newMatrix
    }

    private func checkPlacement(grid: [Int?], x: Int, y: Int, data: [[Int]], direction: Int, mustMatch: Int) -> Bool {

        var matchedIndexCount = 0

        for (yIndex, values) in data.enumerated() {
            for (xIndex, value) in values.enumerated() {

                guard value == 1 else { continue }
                guard let index = self.gridUtility.calcIndex(x + xIndex, y + yIndex) else { return false }

                if grid[index] == nil {
                    return false
                }

                if grid[index] == 1 {
                    matchedIndexCount += 1
                }
            }
        }

        return matchedIndexCount >= mustMatch
    }

    private func warmUpPoop(heatMap: Matrix, x: Int, y: Int, data: [[Int]], direction: Int) {
        for (yIndex, values) in data.enumerated() {
            for (xIndex, value) in values.enumerated() {

                guard let index = self.gridUtility.calcIndex(x + xIndex, y + yIndex) else { continue }
                guard heatMap.data[index] != nil else {
                    continue
                }

                heatMap.data[index]! += value
            }
        }
    }

    private func calcEmptyPoopOffset() -> Int {
        var offset = 0
        for poop in board.poops {
            if poop.isFound { continue }

            for direction in Direction.all() {
                let offsetPoop = OffsetPoop.init(poop, direction: direction)
                let data = offsetPoop.data

                var poopOffset = 0
                for row in data {
                    guard row.reduce(0, +) == 0 else { break }
                    poopOffset += 1
                }

                offset = poopOffset > offset ? poopOffset : offset
            }
        }

        return offset * -1
    }

    init(player: ComputerPlayer) {
        self.gridUtility = player.gridUtility
        self.board = player.board
    }
}
