//
//  computerPlayer.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 23/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class ComputerPlayer {

    let game: Game
    let grid: GridCollectionProtocol
    let gridUtility: GridUtility
    let maxGuesses = 100
    var guesses = [Int]()
    var startTimeBinary = 0

    let guessClosure: (@escaping () -> Void) -> ()

    var deepthCount = 0

    static func makeGuessClosure(closure: @escaping () -> Void) {
        closure()
    }

    static func makeDelayedGuessClosure(closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: { closure() })
    }

    func play(startAt: Int? = nil) {
        startTimeBinary = Int(Date.init().timeIntervalSince1970)/2%2

        guard let startAt = startAt else {
            _ = makeGuess(nil)
            return
        }

        huntForBrownOctober(startAt)
    }

    func guessCount() -> Int {
        return guesses.count
    }

    private func makeGuess(_ index: Int?) -> Bool {

        guard !self.game.gameOver() && guessCount() < maxGuesses else {
            return false
        }

//        print("[\(guessCount() + 1)] Make guess [\(index == nil ? "None" : String(index!))]")

        let (newGuess, oldGuess) = newUnusedGuess(index)

        if oldGuess != nil {
            huntForOsamaBrownLaden(oldGuess!, hitCount: 2)
            return false
        }

        guard let guess = newGuess else { return false }

        let previousScore = self.game.score

        guard let cell = self.grid.getCell(at: guess) else {
            print("[\(guessCount())] Error: Invalid guess \(guess)")
            return false
        }

        cell.touchButton(cell.getButton())

        if self.game.score == previousScore {
//            if let (x, y) = gridUtility.calcXY(guess) {
//                print("[\(guessCount())] Missed! at (\(x), \(y))")
//            }
            if guessCount() == 1 || index == nil {
                self.guessClosure() { _ = self.makeGuess(nil) }
            }
            return false
        }

        let poopIdentifier = self.game.tiles[guess].poopIdentifier

//        if let (x, y) = gridUtility.calcXY(guess) {
//            print("[\(guessCount())] Hit! #\(poopIdentifier) at (\(x), \(y))")
//        }

        if self.game.poops[poopIdentifier - 1].isFound {
//            print("[\(guessCount())] Found! #\(poopIdentifier)")
            self.guessClosure { _ = self.makeGuess(nil) }
            return true
        }

        if guessCount() > 1 && index != nil { return true }

        huntForBrownOctober(guess, direction: 0, hitCount: 1, previousIndex: index)

        return false
    }

    // search for the second poop in a clockwise motion starting at 3 o clock
    private func huntForBrownOctober(_ guessIndex: Int?, direction: Int = 0, hitCount: Int = 0, previousIndex: Int? = nil) {

        guard let guessIndex = guessIndex else {
            _ = self.makeGuess(nil)
            return
        }

        guard hitCount > 0 else {
            _ = self.makeGuess(guessIndex)
            return
        }

//        if let (x, y) = gridUtility.calcXY(guessIndex) {
//            let location = "Hunt! from (\(x), \(y))"
//            let hits = "hits: \(hitCount)"
//            let search = "search direction: \(direction)"
//            let previous = "previous: \(previousIndex == nil ? "None" : String(previousIndex!))"
//            print("[\(guessCount())] \(location) | \(hits) | \(search) | \(previous)")
//        }

        var guess: Int? = nil

        if hitCount == 1 {
            guard let searchIndex = self.gridUtility.adjustIndex(guessIndex, direction: direction, offset: 1) else {
                self.huntForBrownOctober(guessIndex, direction: direction + 1, hitCount: hitCount, previousIndex: previousIndex)
                return
            }

            guess = searchIndex
        }

        self.deepthCount += 1
        if deepthCount > 100 {
            print("\n\n\nError: Exiting -> Too Deep\n\n\n")

            return
        }

        guess = guess == nil ? guessIndex : guess!

        self.guessClosure() {
            if self.makeGuess(guess!) {

                let poopIdent = self.game.tiles[guess!].poopIdentifier

                if self.game.poops[poopIdent - 1].isFound {
                    self.deepthCount = 0
                    return
                }

                self.huntForOsamaBrownLaden(guess!, hitCount: hitCount + 1)
                return
            }

            if hitCount < 2 {
                self.huntForBrownOctober(previousIndex, direction: direction + 1, hitCount: hitCount, previousIndex: previousIndex)
                return
            }

            self.huntForOsamaBrownLaden(previousIndex!, hitCount: hitCount)
            return
        }
    }

    // search by creating a heat map of all possible poops in every position
    private func huntForOsamaBrownLaden(_ index: Int, hitCount: Int) {
        let size = [gridUtility.width, gridUtility.height].max()!

//        let location = "Hunt'n Osama! from (\(xCenter), \(yCenter)) size \(size)"
//        print("[\(guessCount())] \(location)")

        let values = self.game.exportGridValues()
        guard let matrix = self.game.gridUtility.captureGrid(values, at: index, size: size) else {
            print("Error: Invalid matrix")
            return
        }

        let heatMap = prepareHeatMap(matrix)
        let mustMatch = calcMatchSize(data: matrix.data)
        var hottestIndex: Int?

        for n in Array(1 ... mustMatch).reversed() {
            guard hottestIndex == nil else { continue }

            let data = calcHeatMap(from: matrix, to: heatMap, mustMatch: n)
            hottestIndex = self.findHottestIndex(data: data)

//            print("[\(guessCount())] Must match = \(n)")
//            heatMap.data = data
//            heatMap.print("[\(guessCount())] ---- HEAT MAP ----")
        }

        guard hottestIndex != nil else {
            print("Error: No index found")
            return
        }

        huntForBrownOctober(hottestIndex, direction: 0, hitCount: hitCount, previousIndex: index)
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
                    if let (x, y) = gridUtility.calcXY(i) {
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
        if self.guessCount() < 13 && self.gridUtility.width == 10 && self.gridUtility.height == 10 {
            return randomCenterGuessIndex()
        }
        if self.guessCount() < 80 && self.gridUtility.width % 2 == 0  && self.gridUtility.height % 2 == 0 {
            return randomCheckerBoardGuessIndex()
        }
        return randomAllGuessIndex()
    }

    private func randomCenterGuessIndex() -> Int {
        let maxX = gridUtility.width / 2 + 1
        let maxY = gridUtility.height / 2 + 1

        var xGuess = 2 + (Int(arc4random_uniform(UInt32(maxX))) + Int(arc4random_uniform(UInt32(maxX))) + 1) / 2
        let yGuess = 2 + (Int(arc4random_uniform(UInt32(maxY))) + Int(arc4random_uniform(UInt32(maxY))) + 1) / 2

        xGuess = (xGuess / 2 * 2) + (yGuess % 2 == self.startTimeBinary ? 0 : 1)

        return gridUtility.calcIndex(xGuess, yGuess)!
    }

    private func randomCheckerBoardGuessIndex() -> Int {
        var xGuess = Int(arc4random_uniform(UInt32(gridUtility.width)))
        let yGuess = Int(arc4random_uniform(UInt32(gridUtility.height)))

        xGuess = (xGuess / 2 * 2) + (yGuess % 2 == self.startTimeBinary ? 0 : 1)

        return gridUtility.calcIndex(xGuess, yGuess)!

    }

    private func randomAllGuessIndex() -> Int {
        let maxIndex = gridUtility.width * gridUtility.height
        return Int(arc4random_uniform(UInt32(maxIndex)))
    }

    init(game: Game, grid: GridCollectionProtocol, guessClosure: @escaping (@escaping () -> Void) -> () = ComputerPlayer.makeGuessClosure) {
        self.game = game
        self.grid = grid
        self.gridUtility = game.gridUtility
        self.guessClosure = guessClosure
    }
}
