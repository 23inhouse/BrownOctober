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
    var finished = false

    var startAt: Int?

    let guessClosure: (@escaping () -> Void) -> ()

    static func makeGuessClosure(closure: @escaping () -> Void) {
        closure()
    }

    static func makeDelayedGuessClosure(closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: { closure() })
    }

    func play(startAt: Int? = nil) {
        self.startAt = startAt
        _ = makeGuess(startAt)
    }

    func guessCount() -> Int {
        return guesses.count
    }

    private func makeGuess(_ index: Int?) -> Bool {

        guard !self.game.gameOver() && guessCount() < maxGuesses else {
            self.finished = true
            return false
        }

        let guessIndex = self.startAt == nil ? index : nil
        self.startAt = nil
        
        guard let guess = newUnusedGuess(index) else {
            return false
        }

        let previousScore = self.game.score

        guard let cell = self.grid.getCell(at: guess) else {
            print("[\(guessCount())] Invalid guess \(guess)")
            return false
        }

        cell.touchButton(cell.getButton())

        if self.game.score == previousScore {
//            if let (x, y) = gridUtility.calcXY(guess) {
//                print("[\(guessCount())] Missed! at (\(x), \(y))")
//            }
            if guessIndex == nil {
                self.guessClosure() { _ = self.makeGuess(nil) }
            }
            return false
        }

        let poopIdentifier = self.game.tiles[guess].poopIdentifier

//        if let (x, y) = gridUtility.calcXY(guess) {
//            print("[\(guessCount())] Hit! #\(poopIdentifier) at (\(x), \(y))")
//        }

        if self.game.poops[poopIdentifier - 1].isFound {
            self.guessClosure { _ = self.makeGuess(nil) }
            return true
        }

        guard guessIndex == nil else {
            return true
        }

        huntForBrownOctober(guessIndex: guess, pieceCount: 1, direction: 0)

        return false
    }

    private func huntForBrownOctober(guessIndex: Int, pieceCount: Int, direction: Int, flipDirection: Int? = nil, huntCount: Int? = nil) {

//        if let (x, y) = gridUtility.calcXY(guessIndex) {
//            let location = "Hunt! from (\(x), \(y))"
//            let found = "found: \(pieceCount)"
//            let dir = "search direction: \(direction)"
//            let flip = "flipped from direction: \(String(flipDirection != nil ? flipDirection! : -1))"
//            let hunt = "hunt: \(String(describing: huntCount))"
//            print("\n[\(guessCount())] \(location) \(found) | \(dir) | \(flip) | \(hunt)")
//        }

        guard direction < 4 else {
            let newDirection = direction - 4
            let newFlipDirection: Int?

            if flipDirection != nil && flipDirection! > 3 {
                newFlipDirection = flipDirection! - 4
            } else {
                newFlipDirection = flipDirection
            }
            self.huntForBrownOctober(guessIndex: guessIndex, pieceCount: pieceCount, direction: newDirection, flipDirection: newFlipDirection, huntCount: huntCount)
            return
        }

        self.guessClosure() {
            if let searchIndex = self.gridUtility.adjustIndex(guessIndex, direction: direction, offset: 1) {
                if self.makeGuess(searchIndex) {

                    let poopIdent = self.game.tiles[searchIndex].poopIdentifier
                    if self.game.poops[poopIdent - 1].isFound {
                        return
                    }

                    let newFlipDirection: Int?
                    if huntCount == nil {
                        newFlipDirection = flipDirection
                    } else {
                        newFlipDirection = nil
                    }

                    self.huntForBrownOctober(guessIndex: searchIndex, pieceCount: pieceCount + 1, direction: direction, flipDirection: newFlipDirection, huntCount: huntCount)
                    return
                }
            }

            if pieceCount == 1 {
                self.huntForBrownOctober(guessIndex: guessIndex, pieceCount: pieceCount, direction: direction + 1, flipDirection: flipDirection)
                return
            }

            if flipDirection == nil {
                let offset = huntCount == nil ? pieceCount - 1 : 1
                guard let originalIndex = self.gridUtility.adjustIndex(guessIndex, direction: direction + 2, offset: offset) else {
                    print("Couldn't find the original")
                    return
                }

                self.huntForBrownOctober(guessIndex: originalIndex, pieceCount: pieceCount, direction: direction + 2, flipDirection: direction)
                return
            }

            if pieceCount == 2 {
                if huntCount == self.guessCount() {
                    guard let centerIndex = self.gridUtility.adjustIndex(guessIndex, direction: flipDirection!, offset: 1) else {
                        print("Couldn't find the original")
                        return
                    }

                    self.huntForBrownOctober(guessIndex: centerIndex, pieceCount: pieceCount, direction: direction, huntCount: self.guessCount())
                    return

                }

                self.huntForBrownOctober(guessIndex: guessIndex, pieceCount: pieceCount, direction: direction + 1, flipDirection: flipDirection!, huntCount: self.guessCount())
                return
            }

            if pieceCount == 3 {
                let newDirection: Int
                let offset: Int

                if flipDirection != direction {
                    newDirection = direction + 1
                    offset = 1
                } else {
                    newDirection = direction + 2
                    offset = 0
                }

                guard let centerIndex = self.gridUtility.adjustIndex(guessIndex, direction: direction + 2, offset: offset) else {
                    print("Couldn't find the center")
                    return
                }

                self.huntForBrownOctober(guessIndex: centerIndex, pieceCount: pieceCount, direction: newDirection, flipDirection: newDirection)
                return

            }

            if huntCount != nil && huntCount! < 10 {
                self.huntForBrownOctober(guessIndex: guessIndex, pieceCount: pieceCount, direction: direction + 3, flipDirection: flipDirection, huntCount: self.guessCount())
                return
            }
        }
    }

    private func newUnusedGuess(_ index: Int?) -> Int? {
        guard index == nil else {

            guard guesses.contains(index!) else {
                guesses.append(index!)
                return index!
            }

            return nil
        }

        var guess = randomGuessIndex()
        while guesses.contains(guess) {
            guess = randomGuessIndex()
        }
        guesses.append(guess)

        return guess
    }

    private func randomGuessIndex() -> Int {
        if self.guessCount() < 13 && self.gridUtility.width == 10 && self.gridUtility.height == 10 {
            return randomCenterGuessIndex()
        }
        if self.guessCount() < 60 && self.gridUtility.width % 2 == 0  && self.gridUtility.height % 2 == 0 {
            return randomCheckerBoardGuessIndex()
        }
        return randomAllGuessIndex()
    }

    private func randomCenterGuessIndex() -> Int {
        let maxX = gridUtility.width / 2 + 1
        let maxY = gridUtility.height / 2 + 1

        var xGuess = 2 + (Int(arc4random_uniform(UInt32(maxX))) + Int(arc4random_uniform(UInt32(maxX))) + 1) / 2
        let yGuess = 2 + (Int(arc4random_uniform(UInt32(maxY))) + Int(arc4random_uniform(UInt32(maxY))) + 1) / 2

        xGuess = (xGuess / 2 * 2) + (yGuess % 2 == 0 ? 0 : 1)

        return gridUtility.calcIndex(xGuess, yGuess)!
    }

    private func randomCheckerBoardGuessIndex() -> Int {
        var xGuess = Int(arc4random_uniform(UInt32(gridUtility.width)))
        let yGuess = Int(arc4random_uniform(UInt32(gridUtility.height)))

        xGuess = (xGuess / 2 * 2) + (yGuess % 2 == 0 ? 0 : 1)

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
