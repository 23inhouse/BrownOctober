//
//  DirectionTests.swift
//  Brown October Tests
//
//  Created by Benjamin Lewis on 13/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

@testable import Brown_October

class DirectionTests: XCTestCase {

    func testAllCount() {
        let subject = Direction.all()
        XCTAssertEqual(subject.count, 4, "Wrong number of elements in all directions")
    }

    func testAllNames() {
        let subject = Direction.all()
        let expectedNames: [Direction.Named] = [.right, .down, .left, .up]
        for (i, direction) in subject.enumerated() {
            XCTAssertEqual(direction.name, expectedNames[i], "Wrong name at index \(i) in all directions")
        }
    }

    func testRandom() {
        let subject = Direction.random()
        XCTAssertTrue((subject as Any) is Direction, "Random returned the wrong type")
    }

    func testEquatable() {
        let right = Direction(.right)
        let left = Direction(.left)

        XCTAssertNotEqual(left, right, "Different Directions should not be equal")
        XCTAssertEqual(right, right, "The same Directions should be equal")
    }

    func testRotate() {
        let expectations: [(Direction.Named, Direction.Named)] = [
            (.right, .down),
            (.down, .left),
            (.left, .up),
            (.up, .right)
        ]
        for (before, after) in expectations {
            let direction = Direction(before).rotate()
            XCTAssertEqual(direction.name, after, "Wrong direction after rotating at direction")
        }

    }
}
