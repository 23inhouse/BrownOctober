//
//  GridUtilityTests.swift
//  Brown October Tests
//
//  Created by Benjamin Lewis on 29/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

@testable import Brown_October

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
        let game = TestBoardHelper.makeSinglePoopBoard(width: size, height: size, poop: poop, x: 5, y: 5, d: 3)

        let index = gridUtility.calcIndex(5, 5)!
        game.tiles[index - 1].isFound = true
        game.tiles[index + 1].isFlushed = true

        let matrix = gridUtility.captureGrid(game.currentState(), at: index, size: 2)!

        XCTAssertEqual(matrix.width, 3, "The captured matrix is the wrong width")
        XCTAssertEqual(matrix.height, 3, "The captured matrix is the wrong width")
        XCTAssertEqual(matrix.data[4 - 1], 1, "The captured matrix data point should indicate a found poop")
        XCTAssertEqual(matrix.data[4 + 1], nil, "The captured matrix data point should indicate a flushed tile")
    }

    func testCaptureGridWithABiggerPoopAtTopLeft() {
        let size = 7
        let gridUtility = GridUtility(w: size, h: size)

        let poop = Poop.poop5(0)
        let game = TestBoardHelper.makeSinglePoopBoard(width: size, height: size, poop: poop, x: 2, y: 2, d: 1)

        let index = gridUtility.calcIndex(1, 1)!
        let matrix = gridUtility.captureGrid(game.currentState(), at: index, size: 5)!

        XCTAssertEqual(matrix.width, 6, "The captured matrix is the wrong width")
        XCTAssertEqual(matrix.height, 6, "The captured matrix is the wrong width")
    }

    func testCaptureGridWithABiggerPoopAtBottomRight() {
        let size = 7
        let gridUtility = GridUtility(w: size, h: size)

        let poop = Poop.poop5(0)
        let game = TestBoardHelper.makeSinglePoopBoard(width: size, height: size, poop: poop, x: 4, y: 4, d: 3)

        let index = gridUtility.calcIndex(5, 5)!
        let matrix = gridUtility.captureGrid(game.currentState(), at: index, size: 5)!

        XCTAssertEqual(matrix.width, 6, "The captured matrix is the wrong width")
        XCTAssertEqual(matrix.height, 6, "The captured matrix is the wrong width")
    }

    func testCaptureGridWithABiggerPoopInTheMiddle() {
        let size = 7
        let gridUtility = GridUtility(w: size, h: size)

        let poop = Poop.poop5(0)
        let game = TestBoardHelper.makeSinglePoopBoard(width: size, height: size, poop: poop, x: 1, y: 3, d: 0)

        let index = gridUtility.calcIndex(3, 3)!
        let matrix = gridUtility.captureGrid(game.currentState(), at: index, size: 5)!

        XCTAssertEqual(matrix.width, 7, "The captured matrix is the wrong width")
        XCTAssertEqual(matrix.height, 7, "The captured matrix is the wrong width")
    }

    func testCalcAdjustXYAcross() {
        let size = 7
        let gridUtility = GridUtility(w: size, h: size)

        let (x, y) = gridUtility.calcXYAdjustment(from: 13, to: 8)!

        XCTAssertEqual(x, -5, "The X value is incorrect")
        XCTAssertEqual(y, 0, "The Y value is incorrect")
    }

    func testCalcAdjustXYUp() {
        let size = 7
        let gridUtility = GridUtility(w: size, h: size)

        let (x, y) = gridUtility.calcXYAdjustment(from: 9, to: 2)!

        XCTAssertEqual(x, 0, "The X value is incorrect")
        XCTAssertEqual(y, -1, "The Y value is incorrect")
    }

    func testRotateTimes() {
        let matrix = [
            [1,2,3],
            [4,5,6],
            [7,8,9],
        ]

        let expectedMatrixes: [[[Int]]] = [
            [
                [1,2,3],
                [4,5,6],
                [7,8,9],
            ],
            [
                [7,4,1],
                [8,5,2],
                [9,6,3],
            ],
            [
                [9,8,7],
                [6,5,4],
                [3,2,1],
            ],
            [
                [3,6,9],
                [2,5,8],
                [1,4,7],
            ],
        ]

        for (times, expectedMatrix) in expectedMatrixes.enumerated() {
            let newMatrix = GridUtility.rotate(matrix, times: times)
            XCTAssertEqual(newMatrix, expectedMatrix, "The matrix for \(times) is wrong")
        }
    }

    func testOddShapeRotateTimes() {
        let matrix = [
            [1,2,3],
            [4,5,6],
        ]

        let expectedMatrixes: [[[Int]]] = [
            [
                [1,2,3],
                [4,5,6],
            ],
            [
                [4,1],
                [5,2],
                [6,3],
            ],
            [
                [6,5,4],
                [3,2,1],
            ],
            [
                [3,6],
                [2,5],
                [1,4],
            ],
        ]

        for (times, expectedMatrix) in expectedMatrixes.enumerated() {
            let newMatrix = GridUtility.rotate(matrix, times: times)
            XCTAssertEqual(newMatrix, expectedMatrix, "The matrix for \(times) is wrong")
        }
    }
}
