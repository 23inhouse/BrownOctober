//
//  ComputerPlayerTests.swift
//  Brown October Tests
//
//  Created by Benjamin Lewis on 27/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

@testable import Brown_October

// MARK: Mocks
class BoardMock: TouchableBoard {
    let board: Board

    func getButton(at index: Int) -> TouchableButton {
        return GridButtonMock(board: board, index: index)
    }

    init(board: Board) {
        self.board = board
    }
}

class GridButtonMock: TouchableButton {
    let board: Board
    let index: Int

    func touch() {
        _ = board.wipe(at: index)
    }

    init(board: Board, index: Int) {
        self.board = board
        self.index = index
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
        let board = TestBoardHelper.makeSinglePoopBoard(width: 2, height: 1, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 2, "Guess count is wrong")
    }

    func testComputerHuntsAfterMissingTwice() {
        let poop = Poop.poop1(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 5, height: 5, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
    }

    // MARK: Hunt direction tests
    func testComputerHuntsAfterMissing() {
        let poop = Poop.poop1(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 3, height: 1, poop: poop, x: 2, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: 0)

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 3, "Guess count is wrong")
    }

    // MARK: Hunt efficiently tests
    func testComputerHuntsEfficientlyForPoop1() {
        let poop = Poop.poop1(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 7, height: 4, poop: poop, x: 2, y: 2, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertLessThanOrEqual(computerPlayer.guessCount(), 5, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop2() {
        let poop = Poop.poop2(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertLessThanOrEqual(computerPlayer.guessCount(), 5, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop3() {
        let poop = Poop.poop3(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 7, height: 4, poop: poop, x: 2, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertLessThanOrEqual(computerPlayer.guessCount(), 7, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop4() {
        let poop = Poop.poop4(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 7, height: 4, poop: poop, x: 2, y: 2, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertLessThanOrEqual(computerPlayer.guessCount(), 5, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop5() {
        let poop = Poop.poop5(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 7, height: 4, poop: poop, x: 2, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertLessThanOrEqual(computerPlayer.guessCount(), 6, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop6() {
        let poop = Poop.poop6(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 7, height: 4, poop: poop, x: 2, y: 2, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertLessThanOrEqual(computerPlayer.guessCount(), 9, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop6RightEdge() {
        let poop = Poop.poop6(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 4, height: 4, poop: poop, x: 3, y: 2, d: 3)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 4, h: 4).calcIndex(2, 3))

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertLessThanOrEqual(computerPlayer.guessCount(), 7, "Guess count is wrong")
    }

    // MARK: Hunt score tests
    func testComputerHuntsForPoopSize2() {
        let poop = Poop.poop1(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 5, height: 2, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertEqual(board.score, 2, "Final score is wrong")
    }

    func testComputerHuntsForPoopSize3() {
        let poop = Poop.poop2(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 5, height: 2, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertEqual(board.score, 3, "Final score is wrong")
    }

    func testComputerHuntsForPoopSize4() {
        let poop = Poop.poop3(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 5, height: 2, poop: poop, x: 2, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertEqual(board.score, 4, "Final score is wrong")
    }

    func testComputerHuntsForPoopSize5() {
        let poop = Poop.poop5(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 5, height: 2, poop: poop, x: 2, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertEqual(board.score, 5, "Final score is wrong")
    }

    func testComputerHuntsForPoopSize6() {
        let poop = Poop.poop6(0)
        let board = TestBoardHelper.makeSinglePoopBoard(width: 5, height: 2, poop: poop, x: 2, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertEqual(board.score, 6, "Final score is wrong")
    }

    // MARK: Hunt for touching Poops
    func testComputerHuntsForTouchingPoops() {
        let board = TestBoardHelper.makeBoard(width: 5, height: 7)
        let poops = [Poop.poop1(0), Poop.poop4(1)]
        board.set(poops: poops)

        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[0], x: 2, y: 2, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[1], x: 3, y: 4, d: 3)

        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 7).calcIndex(2, 2))

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertEqual(board.score, 6, "Final score is wrong")
        XCTAssertLessThanOrEqual(computerPlayer.guessCount(), 10, "Guess count is wrong")
    }

    func testComputerHuntsForPoopsTouchingALot() {
        let board = TestBoardHelper.makeBoard(width: 7, height: 7)
        let poops = [Poop.poop5(0), Poop.poop6(1)]
        board.set(poops: poops)

        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[0], x: 2, y: 3, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[1], x: 4, y: 5, d: 0)

        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 7).calcIndex(3, 3))

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
        XCTAssertEqual(board.score, 11, "Final score is wrong")
        XCTAssertLessThanOrEqual(computerPlayer.guessCount(), 19, "Guess count is wrong")
    }

    // MARK: Test a full board
    func testComputerSolvesFullGame() {
        let board = TestBoardHelper.makeBoard(width: 10, height: 10)
        let poops = Poop.pinchSomeOff()
        board.set(poops: poops)

        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[0], x: 5, y: 5, d: 1)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[1], x: 6, y: 5, d: 1)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[2], x: 1, y: 4, d: 3)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[3], x: 4, y: 7, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[4], x: 3, y: 3, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[5], x: 3, y: 5, d: 0)

        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 10, h: 10).calcIndex(4, 5))

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
    }

    func testComputerSolvesFullGameWorstCase() {
        let board = TestBoardHelper.makeBoard(width: 10, height: 10)
        let poops = Poop.pinchSomeOff()
        board.set(poops: poops)

        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[0], x: 2, y: 1, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[4], x: 6, y: 0, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[1], x: 1, y: 9, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[3], x: 7, y: 10, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[2], x: 1, y: 3, d: 3)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[5], x: 9, y: 4, d: 3)

        let computerPlayer = TestComputerPlayerHelper.makePlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The game is not over")
    }
}

// MARK: Test helpers
struct TestComputerPlayerHelper {
    static func makePlayer(board: Board) -> ComputerPlayer {
        let boardMock = BoardMock(board: board)
        return ComputerPlayer(board: board, boardViewProtocol: boardMock)
    }
}
