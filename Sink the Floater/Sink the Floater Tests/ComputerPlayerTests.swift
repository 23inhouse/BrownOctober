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
class BoardMock: BoardProtocol {
    let board: Board

    func getButton(at index: Int) -> GridButtonProtocol {
        return GridButtonMock(board: board, index: index)
    }

    init(board: Board) {
        self.board = board
    }
}

class GridButtonMock: GridButtonProtocol {
    let board: Board
    let index: Int

    func touch(_ sender: GridButtonProtocol) {
        if let (_, poop) = board.wipe(at: index) {
            board.tiles[index].markAsFound()

            if poop.isFound {
                for index in 0 ..< board.tiles.count {
                    let tile = self.board.tiles[index]
                    if tile.poopIdentifier != poop.identifier { continue }

                    tile.markAsFlushed()
                }
            }
            return
        }

        board.tiles[index].markAsFlushed()
    }

    func getText() -> String {
        return ""
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
        let board = TestBoardHelper.buildSinglePoopBoard(width: 2, height: 1, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 2, "Guess count is wrong")
    }

    func testComputerHuntsAfterMissingTwice() {
        let poop = Poop.poop1(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 5, height: 5, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
    }

    // MARK: Hunt direction tests
    func testComputerHuntsAfterMissing() {
        let poop = Poop.poop1(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 3, height: 1, poop: poop, x: 1, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: 0)

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 3, "Guess count is wrong")
    }

    // MARK: Hunt efficiently tests
    func testComputerHuntsEfficientlyForPoop1() {
        let poop = Poop.poop1(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 3, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop2() {
        let poop = Poop.poop2(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 4, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop3() {
        let poop = Poop.poop3(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 6, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop4() {
        let poop = Poop.poop4(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 5, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop5() {
        let poop = Poop.poop5(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 6, "Guess count is wrong")
    }

    func testComputerHuntsEfficientlyForPoop6() {
        let poop = Poop.poop6(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 7, height: 4, poop: poop, x: 1, y: 1, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 4).calcIndex(2, 1))

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(computerPlayer.guessCount(), 9, "Guess count is wrong")
    }

    // MARK: Hunt score tests
    func testComputerHuntsForPoopSize2() {
        let poop = Poop.poop1(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 5, height: 2, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(board.score, 2, "Final score is wrong")
    }

    func testComputerHuntsForPoopSize3() {
        let poop = Poop.poop2(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 5, height: 2, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(board.score, 3, "Final score is wrong")
    }

    func testComputerHuntsForPoopSize4() {
        let poop = Poop.poop3(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 5, height: 2, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(board.score, 4, "Final score is wrong")
    }

    func testComputerHuntsForPoopSize5() {
        let poop = Poop.poop5(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 5, height: 2, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(board.score, 5, "Final score is wrong")
    }

    func testComputerHuntsForPoopSize6() {
        let poop = Poop.poop6(0)
        let board = TestBoardHelper.buildSinglePoopBoard(width: 5, height: 2, poop: poop, x: 0, y: 0, d: 0)
        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(board.score, 6, "Final score is wrong")
    }

    // MARK: Hunt for touching Poops
    func testComputerHuntsForTouchingPoops() {
        let board = TestBoardHelper.buildBoard(width: 5, height: 7)
        let poops = [Poop.poop1(0), Poop.poop4(1)]
        board.poops = poops

        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[0], x: 1, y: 1, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[1], x: 2, y: 5, d: 3)

        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 5, h: 7).calcIndex(2, 2))

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(board.score, 6, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 7, "Guess count is wrong")
    }

    func testComputerHuntsForPoopsTouchingALot() {
        let board = TestBoardHelper.buildBoard(width: 7, height: 7)
        let poops = [Poop.poop5(0), Poop.poop6(1)]
        board.poops = poops

        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[0], x: 1, y: 2, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[1], x: 2, y: 3, d: 0)

        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 7, h: 7).calcIndex(3, 3))

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
        XCTAssertEqual(board.score, 11, "Final score is wrong")
        XCTAssertEqual(computerPlayer.guessCount(), 17, "Guess count is wrong")
    }

    // MARK: Test a full board
    func testComputerSolvesFullGame() {
        let board = TestBoardHelper.buildBoard(width: 10, height: 10)
        let poops = Poop.pinchSomeOff()
        board.poops = poops

        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[0], x: 6, y: 5, d: 1)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[1], x: 7, y: 4, d: 1)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[2], x: 2, y: 3, d: 1)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[3], x: 2, y: 6, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[4], x: 3, y: 3, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[5], x: 3, y: 4, d: 0)

        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: GridUtility(w: 10, h: 10).calcIndex(4, 5))

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
    }

    func testComputerSolvesFullGameWorstCase() {
        let board = TestBoardHelper.buildBoard(width: 10, height: 10)
        let poops = Poop.pinchSomeOff()
        board.poops = poops

        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[0], x: 1, y: 0, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[4], x: 4, y: 0, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[1], x: 1, y: 9, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[3], x: 5, y: 9, d: 0)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[2], x: 0, y: 3, d: 1)
        TestBoardHelper.placePoopOnBoard(board: board, poop: poops[5], x: 8, y: 3, d: 1)

        let computerPlayer = TestComputerPlayerHelper.buildPlayer(board: board)

        computerPlayer.play(startAt: nil)

        XCTAssertEqual(board.flushedAllPoops(), true, "The board is not over")
    }
}

// MARK: Test helpers
struct TestComputerPlayerHelper {
    static func buildPlayer(board: Board) -> ComputerPlayer {
        let boardMock = BoardMock(board: board)
        return ComputerPlayer(board: board, boardProtocol: boardMock)
    }
}
