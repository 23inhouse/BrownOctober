//
//  DragRecordTests.swift
//  Brown October Tests
//
//  Created by Benjamin Lewis on 26/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit
import XCTest
@testable import Brown_October

class DragButtonMock: DragableTileProtocol {
    var index: Int

    func contains(point: CGPoint) -> Bool {
        return index == 1
    }

    init(index: Int) {
        self.index = index
    }
}

class DragRecordTests: XCTestCase {
    func testIndexesIsEmpty() {
        let tiles = [DragButtonMock]()
        let dragRecord = DragRecord(tiles: tiles)

        XCTAssertTrue(dragRecord.Indexes().isEmpty, "indexes should be empty")
    }

    func testIndexes() {
        let tiles = [
            DragButtonMock(index: 0),
            DragButtonMock(index: 1),
            DragButtonMock(index: 2),
        ]

        var dragRecord = DragRecord(tiles: tiles)
        let point = CGPoint(x: 1, y: 1)
        dragRecord.storeIndex(at: point)

        XCTAssertEqual(dragRecord.Indexes(), [1], "indexes should contain an array of Int with 1 in it")
    }

    func testIndexesIsUnique() {
        let tiles = [
            DragButtonMock(index: 1),
            DragButtonMock(index: 1),
            DragButtonMock(index: 1),
        ]

        var dragRecord = DragRecord(tiles: tiles)
        let point = CGPoint(x: 1, y: 1)
        dragRecord.storeIndex(at: point)

        XCTAssertEqual(dragRecord.Indexes(), [1], "indexes should contain an array of Int with only 1 in it")
    }
}
