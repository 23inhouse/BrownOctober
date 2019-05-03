//
//  GameTests.swift
//  Sink the Floater Tests
//
//  Created by Benjamin Lewis on 29/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

@testable import Sink_the_Floater

class GameTests: XCTestCase {

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
        let game = TestGameHelper.buildGame(width: 2, height: 1, poops: [poop])

        TestGameHelper.printGrid(tiles: game.tiles, utility: game.gridUtility)

        let placed = game.placePoop(poop, x: 0, y: 0, direction: 0, tiles: &game.tiles, utility: game.gridUtility)

        XCTAssertEqual(placed, true, "The poop should! fit here")
    }

    func testPlacePoopThatIsTooBig() {
        let poop = Poop.poop1(0)
        let game = TestGameHelper.buildGame(width: 1, height: 1, poops: [poop])

        TestGameHelper.printGrid(tiles: game.tiles, utility: game.gridUtility)

        let placed = game.placePoop(poop, x: 0, y: 0, direction: 0, tiles: &game.tiles, utility: game.gridUtility)

        XCTAssertEqual(placed, false, "The poop should not! fit here")
    }

    func testExportGridValues() {
        let game = TestGameHelper.buildGame(width: 3, height: 3)
        let exportValues = game.exportGridValues()

        XCTAssertEqual(exportValues.count, 9, "The export size is incorrect")
        XCTAssertEqual(exportValues.reduce(0) { $0 + $1! }, 0, "All the values should be zero")
    }

    func testExportGridValuesWithFoundTiles() {
        let game = TestGameHelper.buildGame(width: 3, height: 3)
        game.tiles[4].isFound = true
        let exportValues = game.exportGridValues()
        print(exportValues)

        XCTAssertEqual(exportValues.count, 9, "The export size is incorrect")
        XCTAssertEqual(exportValues.reduce(0) { $0 + $1! }, 1, "One of the tiles should be found")
    }

    func testExportGridValuesWithFlushedTiles() {
        let game = TestGameHelper.buildGame(width: 3, height: 3)
        game.tiles[4].isFlushed = true

        let exportValues = game.exportGridValues()
        print(exportValues)

        XCTAssertEqual(exportValues.count, 9, "The export size is incorrect")
        XCTAssertEqual(exportValues.filter { $0 == nil }.count, 1, "One of the tiles should be nil")
    }
}

// MARK: Test helpers
struct TestGameHelper {

    static func buildGame(width: Int, height: Int, poops: [Poop] = []) -> Game {
        let game = Game(width: width, height: height)
        game.createGrid(tiles: &game.tiles, utility: game.gridUtility)
        game.poops = poops

        return game
    }

    static func placeSinglePoopOnGame(game: Game, poop: Poop, x: Int, y: Int, d: Int) {
        game.poops = [poop]
        placePoopOnGame(game: game, poop: poop, x: x, y: y, d: d)
    }

    static func placePoopOnGame(game: Game, poop: Poop, x: Int, y: Int, d: Int) {
        if !game.placePoop(poop, x: x, y: y, direction: d, tiles: &game.tiles, utility: game.gridUtility, check: false) {
            print("---------------------- The poop didn't fit! ----------------------")
            printGrid(tiles: game.tiles, utility: game.gridUtility)
            exit(1)
        }
        printGrid(tiles: game.tiles, utility: game.gridUtility)
    }

    static func buildSinglePoopGame(width: Int, height: Int, poop: Poop, x: Int, y: Int, d: Int) -> Game {
        let game = buildGame(width: width, height: height)
        placeSinglePoopOnGame(game: game, poop: poop, x: x, y: y, d: d)

        return game
    }

    static func printGrid(tiles: [Tile], utility: GridUtility) {
        print("Current Grid layout")
        for y in 0 ..< utility.height {
            let row = y * utility.width
            print(tiles[row ..< (row + utility.width)].map { $0.poopIdentifier })
        }
    }
}
