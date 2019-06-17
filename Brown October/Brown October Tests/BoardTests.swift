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
    func testSetPoopStains() {
        let poop1 = Poop.poop1(0)
        let board = Board(width: 3, height: 3, poops: [poop1])
        var poopStains = [Int: Board.PoopStain]()
        poopStains[poop1.identifier] = Board.PoopStain(x: 1, y:1, direction: Direction(.right))
        board.set(poopStains: poopStains)

        XCTAssertEqual(board.poopStains.count, 1, "Wrong number of poop stains")
    }

    func testSetPoopStainsEmpty() {
        let poop1 = Poop.poop1(0)
        let board = Board(width: 3, height: 3, poops: [poop1])
        let poopStains = [Int: Board.PoopStain]()
        board.set(poopStains: poopStains)

        XCTAssertEqual(board.poopStains.count, 0, "Wrong number of poop stains")
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
        _ = ArrangedPoop(poop, board, direction: Direction(0))?.place(at: (1, 1))

        board.tile(at: 1).markAsFound()
        let subject = board.tileIndexes(for: 1)

        XCTAssertEqual(subject, [0, 1], "Wrong indexes for an the poop")
    }
}

// MARK: Test helpers
struct TestBoardHelper {

    static func makeBoard(width: Int, height: Int, poops: [Poop] = []) -> Board {
        let board = Board(width: width, height: height)
        board.set(poops: poops)

        return board
    }

    static func placeSinglePoopOnBoard(board: Board, poop: Poop, x: Int, y: Int, d: Int) {
        board.set(poops: [poop])
        placePoopOnBoard(board: board, poop: poop, x: x, y: y, d: d)
    }

    static func placePoopOnBoard(board: Board, poop: Poop, x: Int, y: Int, d: Int) {
        if !(ArrangedPoop(poop, board, direction: Direction(d))?.place(at: (x, y)) ?? false) {
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
