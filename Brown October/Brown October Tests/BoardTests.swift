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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPlacePoop() {
        let poop = Poop.poop1(0)
        let board = TestBoardHelper.buildBoard(width: 2, height: 1, poops: [poop])

        let placed = board.place(poop: poop, x: 0, y: 0, direction: 0)

        XCTAssertEqual(placed, true, "The poop should! fit here")
    }

    func testPlacePoopThatIsTooBig() {
        let poop = Poop.poop1(0)
        let board = TestBoardHelper.buildBoard(width: 1, height: 1, poops: [poop])

        let placed = board.place(poop: poop, x: 0, y: 0, direction: 0)

        XCTAssertEqual(placed, false, "The poop should not! fit here")
    }

    func testExportGridValues() {
        let board = TestBoardHelper.buildBoard(width: 3, height: 3)
        let exportValues = board.currentState()

        XCTAssertEqual(exportValues.count, 9, "The export size is incorrect")
        XCTAssertEqual(exportValues.reduce(0) { $0 + $1! }, 0, "All the values should be zero")
    }

    func testExportGridValuesWithFoundTiles() {
        let board = TestBoardHelper.buildBoard(width: 3, height: 3)
        board.tiles[4].isFound = true
        let exportValues = board.currentState()
        print(exportValues)

        XCTAssertEqual(exportValues.count, 9, "The export size is incorrect")
        XCTAssertEqual(exportValues.reduce(0) { $0 + $1! }, 1, "One of the tiles should be found")
    }

    func testExportGridValuesWithFlushedTiles() {
        let board = TestBoardHelper.buildBoard(width: 3, height: 3)
        board.tiles[4].isFlushed = true

        let exportValues = board.currentState()
        print(exportValues)

        XCTAssertEqual(exportValues.count, 9, "The export size is incorrect")
        XCTAssertEqual(exportValues.filter { $0 == nil }.count, 1, "One of the tiles should be nil")
    }
}

// MARK: Test helpers
struct TestBoardHelper {

    static func buildBoard(width: Int, height: Int, poops: [Poop] = []) -> Board {
        let board = Board(width: width, height: height)
        board.tiles = board.cleanTiles()
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
            printGrid(tiles: board.tiles, utility: board.gridUtility)
            exit(1)
        }
//        printGrid(tiles: board.tiles, utility: board.gridUtility)
    }

    static func buildSinglePoopBoard(width: Int, height: Int, poop: Poop, x: Int, y: Int, d: Int) -> Board {
        let board = buildBoard(width: width, height: height)
        placeSinglePoopOnBoard(board: board, poop: poop, x: x, y: y, d: d)

        return board
    }

    static func printGrid(tiles: [Tile], utility: GridUtility) {
        print("Current Grid layout")
        for y in 0 ..< utility.height {
            let row = y * utility.width
            print(tiles[row ..< (row + utility.width)].map { $0.poopIdentifier })
        }
    }
}
