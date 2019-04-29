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
        _ = game.wipe(at: row)
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

    // MARK: Hunt direction tests
    func testComputerHuntsAfterMissing() {
        let poop = Poop.poop1(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 3, height: 1, poop: poop, x: 1, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: 0)

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 2, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 3, "Guess count is wrong")
    }

    func testComputerHuntsRightFirst() {
        let poop = Poop.poop1(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 3, height: 1, poop: poop, x: 1, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: 1)

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 2, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 2, "Guess count is wrong")
    }

    func testComputerHuntsDownSecond() {
        let poop = Poop.poop1(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 4, height: 4, poop: poop, x: 1, y: 1, d: 1)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 4, h: 4).calcIndex(1, 1))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 2, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 3, "Guess count is wrong")
    }

    func testComputerHuntsLeftThird() {
        let poop = Poop.poop1(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 4, height: 4, poop: poop, x: 2, y: 1, d: 2)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 4, h: 4).calcIndex(2, 1))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 2, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 4, "Guess count is wrong")
    }

    func testComputerHuntsUpForth() {
        let poop = Poop.poop1(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 4, height: 4, poop: poop, x: 2, y: 2, d: 3)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 4, h: 4).calcIndex(2, 2))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 2, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 5, "Guess count is wrong")
    }

    // MARK: Flip tests
    func testComputerFlipsDirectionLeft() {
        let poop = Poop.poop2(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 5).calcIndex(2, 1))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 3, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 4, "Guess count is wrong")
    }

    func testComputerFlipsDirectionUp() {
        let poop = Poop.poop2(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 2, y: 1, d: 1)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 5).calcIndex(2, 2))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 3, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 5, "Guess count is wrong")
    }

    // MARK: Tetris piece tests
    func testComputerFindsTheUpSidePiece() {
        let poop = Poop.poop3(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 1, y: 2, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 5).calcIndex(2, 3))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 4, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 6, "Guess count is wrong")
    }

    func testComputerFindsTheRightSidePiece() {
        let poop = Poop.poop3(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 2, y: 1, d: 1)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 5).calcIndex(2, 1))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 4, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 7, "Guess count is wrong")
    }

    func testComputerFindsTheDownSidePiece() {
        let poop = Poop.poop3(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 3, y: 2, d: 2)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 5).calcIndex(2, 2))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 4, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 7, "Guess count is wrong")
    }

    func testComputerFindsTheLeftSidePiece() {
        let poop = Poop.poop3(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 1, y: 3, d: 3)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 5).calcIndex(2, 2))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 4, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 7, "Guess count is wrong")
    }

    func testComputerFindsTheBottomRow() {
        let poop = Poop.poop3(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 1, y: 2, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 5).calcIndex(2, 2))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 4, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 8, "Guess count is wrong")
    }

    func testComputerFindsTheLeftRowStartingOnRow() {
        let poop = Poop.poop3(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 2, y: 1, d: 1)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 5).calcIndex(2, 2))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 4, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 7, "Guess count is wrong")
    }

    func testComputerFindsTheLeftRowStartingOnRight() {
        let poop = Poop.poop3(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 2, y: 1, d: 1)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 5).calcIndex(3, 2))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 4, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 8, "Guess count is wrong")
    }

    func testComputerFindsTheTopRow() {
        let poop = Poop.poop3(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 3, y: 2, d: 2)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 5).calcIndex(2, 3))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 4, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 9, "Guess count is wrong")
    }

    func testComputerFindsTheRightRowStartingOnLeft() {
        let poop = Poop.poop3(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 1, y: 3, d: 3)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 5).calcIndex(1, 2))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 4, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 8, "Guess count is wrong")
    }

    func testComputerFindsTheRightRowStaringOnRow() {
        let poop = Poop.poop3(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 5, height: 5, poop: poop, x: 1, y: 3, d: 3)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 5).calcIndex(2, 2))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 4, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 7, "Guess count is wrong")
    }

    // MARK: Big wierd piece tests
    func testComputerFindsTheNextRowOnBottom() {
        let poop = Poop.poop6(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 6, height: 6, poop: poop, x: 1, y: 2, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 6, h: 6).calcIndex(2, 2))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 6, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 11, "Guess count is wrong")
    }

    func testComputerFindsTheNextRowOnRight() {
        let poop = Poop.poop6(0)
        let game = TestGameHelper.buildSinglePoopGame(width: 6, height: 6, poop: poop, x: 2, y: 1, d: 1)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(game: game)

        computerPlayer.play(startAt: GridUtility(w: 6, h: 6).calcIndex(2, 3))

        XCTAssertEqual(game.gameOver(), true, "The game is not over")
        XCTAssertEqual(game.score, 6, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 11, "Guess count is wrong")
    }
}

// MARK: Test helpers
struct TestComputerPlayerHelper {
    static func buildPlayer(game: Game) -> ComputerPlayer {
        let gridCollectionMock = GridCollectionMock(game: game)
        return ComputerPlayer(game: game, grid: gridCollectionMock)
    }
}
