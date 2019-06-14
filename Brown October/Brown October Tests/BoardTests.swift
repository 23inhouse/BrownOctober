//
//  BoardTests.swift
//  Brown October Tests
//
//  Created by Benjamin Lewis on 29/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

@testable import Brown_October

class BoardTests: XCTestCase {
    func testPlacePoop() {
        let poop = Poop.poop1(0)
        let board = TestBoardHelper.makeBoard(width: 2, height: 1, poops: [poop])

        let placed = board.place(poop: poop, x: 1, y: 1, direction: 0)

        XCTAssertEqual(placed, true, "The poop should! fit here")
    }

    func testPlacePoopThatIsTooBig() {
        let poop = Poop.poop1(0)
        let board = TestBoardHelper.makeBoard(width: 1, height: 1, poops: [poop])

        let placed = board.place(poop: poop, x: 0, y: 0, direction: 0)

        XCTAssertEqual(placed, false, "The poop should not! fit here")
    }

    func testExportGridValues() {
        let board = TestBoardHelper.makeBoard(width: 3, height: 3)
        let exportValues = board.currentState()

        XCTAssertEqual(exportValues.count, 9, "The export size is incorrect")
        XCTAssertEqual(exportValues.reduce(0) { $0 + $1! }, 0, "All the values should be zero")
    }

    func testExportGridValuesWithFoundTiles() {
        let board = TestBoardHelper.makeBoard(width: 3, height: 3)
        board.tile(at: 4).markAsFound()
        let exportValues = board.currentState()
        print(exportValues)

        XCTAssertEqual(exportValues.count, 9, "The export size is incorrect")
        XCTAssertEqual(exportValues.reduce(0) { $0 + $1! }, 1, "One of the tiles should be found")
    }

    func testExportGridValuesWithFlushedTiles() {
        let board = TestBoardHelper.makeBoard(width: 3, height: 3)
        board.tile(at: 4).markAsFlushed()

        let exportValues = board.currentState()
        print(exportValues)

        XCTAssertEqual(exportValues.count, 9, "The export size is incorrect")
        XCTAssertEqual(exportValues.filter { $0 == nil }.count, 1, "One of the tiles should be nil")
    }

    func testFirstIncompletePoopIndex() {
        let board = TestBoardHelper.makeBoard(width: 2, height: 1)

        board.tile(at: 1).markAsFound()
        let subject = board.firstIncompletePoopIndex()

        XCTAssertEqual(subject, 1, "Wrong index for an incomplete poop")
    }

    func testTileIndexes() {
        let board = TestBoardHelper.makeBoard(width: 3, height: 3)

        let poop = Poop.poop1(0)
        _ = board.place(poop: poop, x: 1, y: 1, direction: 0)

        board.tile(at: 1).markAsFound()
        let subject = board.tileIndexes(for: 1)

        XCTAssertEqual(subject, [0, 1], "Wrong indexes for an the poop")
    }
}

// MARK: Test helpers
struct TestBoardHelper {

    static func makeBoard(width: Int, height: Int, poops: [Poop] = []) -> Board {
        let board = Board(width: width, height: height)
        board.poops = poops

        return board
    }

    static func placeSinglePoopOnBoard(board: Board, poop: Poop, x: Int, y: Int, d: Int) {
        board.poops = [poop]
        placePoopOnBoard(board: board, poop: poop, x: x, y: y, d: d)
    }

    static func placePoopOnBoard(board: Board, poop: Poop, x: Int, y: Int, d: Int) {
        if !board.place(poop: poop, x: x, y: y, direction: d, check: false) {
            print("---------------------- The poop didn't fit! ----------------------")
            board.print()
            exit(1)
        }
//        board.print()
    }

    static func makeSinglePoopBoard(width: Int, height: Int, poop: Poop, x: Int, y: Int, d: Int) -> Board {
        let board = makeBoard(width: width, height: height)
        placeSinglePoopOnBoard(board: board, poop: poop, x: x, y: y, d: d)

        return board
    }
}
