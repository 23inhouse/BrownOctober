//
//  computerPlayer.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 23/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

typealias NextGuess = (@escaping () -> Void) -> ()

class ComputerPlayer {

    let debug = false

    let game: Game
    let board: BoardProtocol
    let gridUtility: GridUtility
    let maxGuesses = 100
    var guesses = [Int]()

    let nextGuessClosure: NextGuess

    static func makeGuessClosure(closure: @escaping () -> Void) {
        closure()
    }

    static func makeDelayedGuessClosure(closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: { closure() })
    }

    func play(startAt: Int? = nil) {
        huntForBrownOctober(startAt)
    }

    func guessCount() -> Int {
        return guesses.count
    }

    private func makeGuess(_ index: Int) -> Bool {

        let previousScore = self.game.score

        let button = board.getButton(at: index)
        button.touch(button)

        if self.game.score == previousScore {
            if debug == true, let (x, y) = gridUtility.calcXY(index) {
                print("[\(guessCount())] Missed! at (\(x), \(y))")
            }
            return false
        }

        let poopIdentifier = self.game.tiles[index].poopIdentifier
        if debug == true, let (x, y) = gridUtility.calcXY(index) {
            print("[\(guessCount())] Hit! #\(poopIdentifier) at (\(x), \(y))")
        }
        if debug == true, self.game.poops[poopIdentifier - 1].isFound {
            print("[\(guessCount())] Found! #\(poopIdentifier)")
        }

        return true
    }

    // the main hunting controller
    private func huntForBrownOctober(_ guessIndex: Int?) {

        guard !self.game.gameOver() && guessCount() < maxGuesses else { return }

        let (newGuessIndex, incompletePoopIndex) = newUnusedGuess(guessIndex)

        if incompletePoopIndex != nil {
            huntForOsamaBrownLaden(incompletePoopIndex!)
            return
        }

        guard let index = newGuessIndex else {
            print("\n\n\nError: Serious problems couldn't get a new guess index")
            return
        }

        if debug == true, let (x, y) = gridUtility.calcXY(index) {
            print("[\(guessCount())] Hunting at (\(x), \(y))")
        }

        if self.makeGuess(index) {
            if self.game.gameOver() { return }

            let poopIdent = self.game.tiles[index].poopIdentifier

            let poop = self.game.poops[poopIdent - 1]
            if poop.isFound {
                self.nextGuessClosure() { self.huntForBrownOctober(nil) }
                return
            }

            self.nextGuessClosure() { self.huntForOsamaBrownLaden(index) }
            return
        }

        self.nextGuessClosure() { self.huntForBrownOctober(nil) }
        return
    }

    // search by creating a heat map of all possible poops in every position
    private func huntForOsamaBrownLaden(_ index: Int) {

        if debug == true, let (x, y) = gridUtility.calcXY(index) {
            print("[\(guessCount())] Hunt round (\(x), \(y))")
        }

        guard let data = calcHeatMaps(index) else {
            print("Error: No data found")
            return
        }

        let hottestIndex = self.findHottestIndex(data: data)
        guard hottestIndex != nil else {
            print("Error: No index found")
            return
        }

        huntForBrownOctober(hottestIndex)
    }

    private func calcHeatMaps(_ index: Int) -> [Int?]? {
        let size = [gridUtility.width, gridUtility.height].max()!

        let values = self.game.exportGridValues()
        guard let matrix = self.game.gridUtility.captureGrid(values, at: index, size: size) else {
            print("Error: Invalid matrix")
            return nil
        }

        let heatMap = prepareHeatMap(matrix)
        let mustMatch = calcMatchSize(data: matrix.data)

        for n in Array(0 ... mustMatch).reversed() {
            let data = calcHeatMap(from: matrix, to: heatMap, mustMatch: n)
            if self.findHottestIndex(data: data) != nil {
                if debug == true {
                    print("[\(guessCount())] Must match = \(n)")
                    heatMap.data = data
                    heatMap.print("[\(guessCount())] ---- HEAT MAP ----")
                }
                return data
            }
        }

        return nil
    }

    private func calcHeatMap(from matrix: Matrix, to heatMap: Matrix, mustMatch: Int) -> [Int?] {
        for poop in game.poops {
            if poop.isFound { continue }

            for direction in Array(0 ..< 4) {
                let poopData = GridUtility.rotate(poop.data, times: direction)

                for yMat in Array(0 ..< matrix.height) {
                    for xMat in Array(0 ..< matrix.width) {

                        if checkPlacement(grid: matrix.data, x: xMat, y: yMat, data: poopData, direction: direction, mustMatch: mustMatch) {
//                            print("[\(guessCount())] It fits at (\(xMat),\(yMat)) going (\(direction))")
                            warmUpPoop(heatMap: heatMap, x: xMat, y: yMat, data: poopData, direction: direction)
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
        let max = game.biggestPoop() - 1
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

                guard let (xAdjust, yAdjust) = GridUtility.rotateXY(xIndex, yIndex, direction) else {
                    return false
                }

                guard let index = self.gridUtility.calcIndex(x + xAdjust, y + yAdjust) else {
                    return false
                }

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

                guard let (xAdjust, yAdjust) = GridUtility.rotateXY(xIndex, yIndex, direction) else {
                    continue
                }

                guard let index = self.gridUtility.calcIndex(x + xAdjust, y + yAdjust) else {
                    continue
                }

                guard heatMap.data[index] != nil else {
                    continue
                }

                heatMap.data[index]! += value
            }
        }
    }

    private func newUnusedGuess(_ index: Int?) -> (Int?, Int?) {
        if index == nil {
            for (i, tile) in game.tiles.enumerated() {
                if tile.isFound && !tile.isFlushed {
                    if debug == true, let (x, y) = gridUtility.calcXY(i) {
                        print("Continuing from incomplete poop at (\(x), \(y))")
                    }
                    return (nil, i)
                }
            }
        }

        if index != nil {

            guard guesses.contains(index!) else {
                guesses.append(index!)
                return (index!, nil)
            }

            return (nil, nil)
        }

        var guess = randomGuessIndex()
        while guesses.contains(guess) {
            guess = randomGuessIndex()
        }
        guesses.append(guess)

        return (guess, nil)
    }

    private func randomGuessIndex() -> Int {
        let bestGuesses = calcHeatMaps(0)!

        let heatMap = Matrix()
        heatMap.width = self.gridUtility.width
        heatMap.height = self.gridUtility.height
        heatMap.data = bestGuesses
        if debug == true {
            heatMap.print("Best Random Guess")
        }

        let highests = bestGuesses.filter({ $0 != nil }).sorted(by: {$0! > $1!})
        let highest = highests.first!

        var bestIndexes = [Int]()
        for (i, v) in bestGuesses.enumerated() {
            guard v == highest else { continue }
            bestIndexes.append(i)
        }

        return bestIndexes[Int(arc4random_uniform(UInt32(bestIndexes.count)))]
    }

    init(game: Game, board: BoardProtocol, nextGuessClosure: NextGuess? = nil) {
        self.game = game
        self.board = board
        self.gridUtility = game.gridUtility
        self.nextGuessClosure = nextGuessClosure == nil ? ComputerPlayer.makeGuessClosure : nextGuessClosure!
    }
}
