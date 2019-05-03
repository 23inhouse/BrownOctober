//
//  ComputerPlayerTests.swift
//  Sink the Floater Tests
//
//  Created by Benjamin Lewis on 27/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

@testable import Sink_the_Floater

// MARK: Mocks
class GridCollectionMock: GridCollectionProtocol {
    let game: Game

    func getCell(at row: Int) -> GridCellProtocol? {
        return GridCellMock(game: game, row: row)
    }

    init(game: Game) {
        self.game = game
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GridCellMock: GridCellProtocol {
    let game: Game
    let row: Int

    func touchButton(_ sender: UIButton) {
        if let (_, poop) = game.wipe(at: row) {
            game.tiles[row].markAsFound()

            if poop.isFound {
                for index in 0 ..< game.tiles.count {
                    let tile = self.game.tiles[index]
                    if tile.poopIdentifier != poop.identifier { continue }

                    tile.markAsFlushed()
                }
            }
            return
        }

        game.tiles[row].markAsFlushed()
    }

    func getButton() -> UIButton {
        return UIButton()
    }

    init(game: Game, row: Int) {
        self.game = game
        self.row = row
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: TESTS
class ComputerPlayerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: Hunt after missing tests
    func testComputerHuntsWithNoStartAtArgument() {
        let poop = Poop.poop1(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 2, height: 1, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 2, "Guess count is wrong")
    }

    func testComputerHuntsAfterMissingTwice() {
        let poop = Poop.poop1(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
    }

    // MARK: Hunt direction tests
    func testComputerHuntsAfterMissing() {
        let poop = Poop.poop1(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 3, height: 1, poop: poop, x: 1, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: 0)

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 3, "Guess count is wrong")
    }

    // MARK: Hunt efficiently tests
    func testComputerHuntsEfficientlyForPoop1() {
        let poop = Poop.poop1(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 3, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop2() {
        let poop = Poop.poop2(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 4, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop3() {
        let poop = Poop.poop3(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 6, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop4() {
        let poop = Poop.poop4(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 5, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop5() {
        let poop = Poop.poop5(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 6, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop6() {
        let poop = Poop.poop6(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 9, "Guess count is wrong")
    }

    // MARK: Hunt score tests
    func testComputerHuntsForPoopSize2() {
        let poop = Poop.poop1(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 2, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 2, "Final score is wrong")
    }

    func testComputerHuntsForPoopSize3() {
        let poop = Poop.poop2(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 2, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 3, "Final score is wrong")
    }

    func testComputerHuntsForPoopSize4() {
        let poop = Poop.poop3(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 2, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 4, "Final score is wrong")
    }

    func testComputerHuntsForPoopSize5() {
        let poop = Poop.poop5(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 2, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 5, "Final score is wrong")
    }

    func testComputerHuntsForPoopSize6() {
        let poop = Poop.poop6(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 2, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 6, "Final score is wrong")
    }

    // MARK: Hunt for touching Poops
    func testComputerHuntsForTouchingPoops() {
        let game = TestGameHelper.buildGame(width: 5, height: 7)
        let poops = [Poop.poop1(0), Poop.poop4(1)]
        game.poops = poops

        TestGameHelper.placePoopOnGame(game: game, poop: poops[0], x: 1, y: 1, d: 0)
        TestGameHelper.placePoopOnGame(game: game, poop: poops[1], x: 2, y: 5, d: 3)

        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 7).calcIndex(2, 2))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 6, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 7, "Guess count is wrong")
    }

    func testComputerHuntsForPoopsTouchingALot() {
        let game = TestGameHelper.buildGame(width: 7, height: 7)
        let poops = [Poop.poop5(0), Poop.poop6(1)]
        game.poops = poops

        TestGameHelper.placePoopOnGame(game: game, poop: poops[0], x: 1, y: 2, d: 0)
        TestGameHelper.placePoopOnGame(game: game, poop: poops[1], x: 2, y: 3, d: 0)

        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 7).calcIndex(3, 3))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 11, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 17, "Guess count is wrong")
    }

    // MARK: Test a full game
    func testComputerSolvesFullGame() {
        let game = TestGameHelper.buildGame(width: 10, height: 10)
        let poops = Poop.pinchSomeOff()
        game.poops = poops

        TestGameHelper.placePoopOnGame(game: game, poop: poops[0], x: 6, y: 5, d: 1)
        TestGameHelper.placePoopOnGame(game: game, poop: poops[1], x: 7, y: 4, d: 1)
        TestGameHelper.placePoopOnGame(game: game, poop: poops[2], x: 2, y: 3, d: 1)
        TestGameHelper.placePoopOnGame(game: game, poop: poops[3], x: 2, y: 6, d: 0)
        TestGameHelper.placePoopOnGame(game: game, poop: poops[4], x: 3, y: 3, d: 0)
        TestGameHelper.placePoopOnGame(game: game, poop: poops[5], x: 3, y: 4, d: 0)

        TestGameHelper.printGrid(tiles: game.tiles, utility: game.gridUtility)

        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 10, h: 10).calcIndex(4, 5))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
    }
}

// MARK: Test helpers
struct TestComputerPlayerHelper {
    static func buildPlayer(game: Game) -> ComputerPlayer {
        let gridCollectionMock = GridCollectionMock(game: game)
        return ComputerPlayer(game: game, grid: gridCollectionMock)
    }
}