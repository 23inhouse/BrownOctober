//
//  GridUtilityTests.swift
//  Sink the Floater Tests
//
//  Created by Benjamin Lewis on 29/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

@testable import Sink_the_Floater

class GridUtilityTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCaptureGridWithASmallerPoop() {
        let size = 10
        let gridUtility = GridUtility(w: size, h: size)

        let poop = Poop.poop2(0)
        let game = TestGameHelper.buildSinglePoopGame(width: size, height: size, poop: poop, x: 5, y: 5, d: 3)

        let index = gridUtility.calcIndex(5, 5)!
        game.tiles[index - 1].isFound = true
        game.tiles[index + 1].isFlushed = true

        let matrix = gridUtility.captureGrid(game.exportGridValues(), at: index, size: 2)!

        XCTAssertEqual(matrix.width, 3, file: "The captured matrix is the wrong width")
        XCTAssertEqual(matrix.height, 3, "The captured matrix is the wrong width")
        XCTAssertEqual(matrix.data[4 - 1], 1, "The captured matrix data point should indicate a found poop")
        XCTAssertEqual(matrix.data[4 + 1], nil, "The captured matrix data point should indicate a flushed tile")
    }

    func testCaptureGridWithABiggerPoopAtTopLeft() {
        let size = 7
        let gridUtility = GridUtility(w: size, h: size)

        let poop = Poop.poop5(0)
        let game = TestGameHelper.buildSinglePoopGame(width: size, height: size, poop: poop, x: 1, y: 1, d: 1)

        let index = gridUtility.calcIndex(1, 1)!
        let matrix = gridUtility.captureGrid(game.exportGridValues(), at: index, size: 5)!

        XCTAssertEqual(matrix.width, 6, file: "The captured matrix is the wrong width")
        XCTAssertEqual(matrix.height, 6, "The captured matrix is the wrong width")
    }

    func testCaptureGridWithABiggerPoopAtBottomRight() {
        let size = 7
        let gridUtility = GridUtility(w: size, h: size)

        let poop = Poop.poop5(0)
        let game = TestGameHelper.buildSinglePoopGame(width: size, height: size, poop: poop, x: 5, y: 5, d: 3)

        let index = gridUtility.calcIndex(5, 5)!
        let matrix = gridUtility.captureGrid(game.exportGridValues(), at: index, size: 5)!

        XCTAssertEqual(matrix.width, 6, file: "The captured matrix is the wrong width")
        XCTAssertEqual(matrix.height, 6, "The captured matrix is the wrong width")
    }

    func testCaptureGridWithABiggerPoopInTheMiddle() {
        let size = 7
        let gridUtility = GridUtility(w: size, h: size)

        let poop = Poop.poop5(0)
        let game = TestGameHelper.buildSinglePoopGame(width: size, height: size, poop: poop, x: 1, y: 3, d: 0)

        let index = gridUtility.calcIndex(3, 3)!
        let matrix = gridUtility.captureGrid(game.exportGridValues(), at: index, size: 5)!

        XCTAssertEqual(matrix.width, 7, file: "The captured matrix is the wrong width")
        XCTAssertEqual(matrix.height, 7, "The captured matrix is the wrong width")
    }
}
