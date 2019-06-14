//
//  GridTests.swift
//  Brown October Tests
//
//  Created by Benjamin Lewis on 13/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

@testable import Brown_October

class GridTests: XCTestCase {
    func testCleanTiles() {
        let size = 3
        let grid = Grid(width: size, height: size)

        let tile = grid.tile(at: 0)
        tile.markAsFlushed()
        tile.markAsFound()
        tile.set(identifier: 1)

        grid.cleanTiles()

        for i in 0 ..< (size * size) {
            let tile = grid.tile(at: i)
            XCTAssertFalse(tile.isFound, "The tile should not be found")
            XCTAssertFalse(tile.isFlushed, "The tile should not be found")
            XCTAssertEqual(tile.poopIdentifier, 0, "The tile should not have a poop")
        }
    }

    func testNumberOfFlushedTiles() {
        let size = 3
        let grid = Grid(width: size, height: size)

        for i in 0 ..< (size * size) {
            let tile = grid.tile(at: i)
            guard i % 2 == 0 else { continue }
            tile.markAsFlushed()
        }

        XCTAssertEqual(grid.numberOfFlushedTiles(), 5, "The number of flushed tiles is wrong")
    }

    func testNumberOfFoundTiles() {
        let size = 3
        let grid = Grid(width: size, height: size)

        for i in 0 ..< (size * size) {
            let tile = grid.tile(at: i)
            guard i % 2 == 0 else { continue }
            tile.markAsFound()
        }

        XCTAssertEqual(grid.numberOfFoundTiles(), 5, "The number of found tiles is wrong")
    }

    func testTile() {
        let grid = Grid(width: 2, height: 1)
        grid.tile(at: 0).set(identifier: 1)

        XCTAssertEqual(grid.tile(at: 0).poopIdentifier, 1, "Found the wrong tile")
        XCTAssertEqual(grid.tile(at: 1).poopIdentifier, 0, "Found the wrong tile")
    }
}
