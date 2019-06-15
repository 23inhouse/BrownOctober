//
//  OffsetPoopTests.swift
//  Brown October Tests
//
//  Created by Benjamin Lewis on 10/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

@testable import Brown_October

class OffsetPoopTests: XCTestCase {
    func testMake() {
        let poop = Poop.poop1()
        let expectedPoops:[Int:Direction.Named] = [
            0: .right,
            1: .down,
            2: .left,
            3: .up,
        ]

        for (directionInt, directionName) in expectedPoops {
            let offsetPoop = OffsetPoop.make(poop, direction: directionInt)
            XCTAssertEqual(offsetPoop.direction.name, directionName, "The direction name for \(directionInt) is wrong")
        }
    }

    func testOffsetPoop1() {
        let poop = Poop.poop1()

        let expectedOffsets:[Int:(Int,Int,Int)] = [
            0: (1, 0, 0),
            1: (1, 0, 0),
            2: (1, 0, 0),
            3: (1, 0, 0),
        ]

        for (direction, expectOffset) in expectedOffsets {
            let offsetPoop = OffsetPoop.make(poop, direction: direction)
            let centerOffset = offsetPoop.centerOffset
            let offset = offsetPoop.offset
            XCTAssertEqual(centerOffset, expectOffset.0, "The center offset for direction \(direction) is wrong")
            XCTAssertEqual(offset.x, expectOffset.1, "The x offset for direction \(direction) is wrong")
            XCTAssertEqual(offset.y, expectOffset.2, "The y offset for direction \(direction) is wrong")
        }
    }

    func testOffsetPoop2() {
        let poop = Poop.poop2()

        let expectedOffsets:[Int:(Int,Int,Int)] = [
            0: (1, 0, 1),
            1: (1, 1, 0),
            2: (1, 0, 1),
            3: (1, 1, 0),
        ]

        for (direction, expectOffset) in expectedOffsets {
            let offsetPoop = OffsetPoop.make(poop, direction: direction)
            let centerOffset = offsetPoop.centerOffset
            let offset = offsetPoop.offset
            XCTAssertEqual(centerOffset, expectOffset.0, "The center offset for direction \(direction) is wrong")
            XCTAssertEqual(offset.x, expectOffset.1, "The x offset for direction \(direction) is wrong")
            XCTAssertEqual(offset.y, expectOffset.2, "The y offset for direction \(direction) is wrong")
        }
    }

    func testOffsetPoop3() {
        let poop = Poop.poop3()

        let expectedOffsets:[Int:(Int,Int,Int)] = [
            0: (1, 0, 0),
            1: (1, 0, 0),
            2: (1, 0, 0),
            3: (1, 0, 0),
        ]

        for (direction, expectOffset) in expectedOffsets {
            let offsetPoop = OffsetPoop.make(poop, direction: direction)
            let centerOffset = offsetPoop.centerOffset
            let offset = offsetPoop.offset
            XCTAssertEqual(centerOffset, expectOffset.0, "The center offset for direction \(direction) is wrong")
            XCTAssertEqual(offset.x, expectOffset.1, "The x offset for direction \(direction) is wrong")
            XCTAssertEqual(offset.y, expectOffset.2, "The y offset for direction \(direction) is wrong")
        }
    }

    func testOffsetPoop4() {
        let poop = Poop.poop4()

        let expectedOffsets:[Int:(Int,Int,Int)] = [
            0: (2, 0, 0),
            1: (2, 0, 0),
            2: (2, 0, 0),
            3: (2, 0, 0),
        ]

        for (direction, expectOffset) in expectedOffsets {
            let offsetPoop = OffsetPoop.make(poop, direction: direction)
            let centerOffset = offsetPoop.centerOffset
            let offset = offsetPoop.offset
            XCTAssertEqual(centerOffset, expectOffset.0, "The center offset for direction \(direction) is wrong")
            XCTAssertEqual(offset.x, expectOffset.1, "The x offset for direction \(direction) is wrong")
            XCTAssertEqual(offset.y, expectOffset.2, "The y offset for direction \(direction) is wrong")
        }
    }

    func testOffsetPoop5() {
        let poop = Poop.poop5()

        let expectedOffsets:[Int:(Int,Int,Int)] = [
            0: (2, 0, 2),
            1: (2, 2, 0),
            2: (2, 0, 2),
            3: (2, 2, 0),
        ]

        for (direction, expectOffset) in expectedOffsets {
            let offsetPoop = OffsetPoop.make(poop, direction: direction)
            let centerOffset = offsetPoop.centerOffset
            let offset = offsetPoop.offset
            XCTAssertEqual(centerOffset, expectOffset.0, "The center offset for direction \(direction) is wrong")
            XCTAssertEqual(offset.x, expectOffset.1, "The x offset for direction \(direction) is wrong, expected \(expectOffset.1) got \(offset.x)")
            XCTAssertEqual(offset.y, expectOffset.2, "The y offset for direction \(direction) is wrong, expected \(expectOffset.2) got \(offset.y)")
        }
    }

    func testOffsetPoop6() {
        let poop = Poop.poop6()

        let expectedOffsets:[Int:(Int,Int,Int)] = [
            0: (2, 0, 0),
            1: (2, 0, 0),
            2: (2, 0, 0),
            3: (2, 0, 0),
        ]

        for (direction, expectOffset) in expectedOffsets {
            let offsetPoop = OffsetPoop.make(poop, direction: direction)
            let centerOffset = offsetPoop.centerOffset
            let offset = offsetPoop.offset
            XCTAssertEqual(centerOffset, expectOffset.0, "The center offset for direction \(direction) is wrong")
            XCTAssertEqual(offset.x, expectOffset.1, "The x offset for direction \(direction) is wrong")
            XCTAssertEqual(offset.y, expectOffset.2, "The y offset for direction \(direction) is wrong")
        }
    }

    func testPoop6Flipping() {
        let poop = Poop.poop6()

        let expectedData: [Direction.Named: [[Int]]] = [
            .right: [
                [0,0,0,0],
                [0,1,1,1],
                [1,1,1,0],
                [0,0,0,0],
            ],
            .down: [
                [0,1,0,0],
                [0,1,1,0],
                [0,1,1,0],
                [0,0,1,0],
            ],
            .left: [
                [0,0,0,0],
                [1,1,1,0],
                [0,1,1,1],
                [0,0,0,0],
            ],
            .up: [
                [0,0,1,0],
                [0,1,1,0],
                [0,1,1,0],
                [0,1,0,0],
            ],
        ]

        for (direction, data) in expectedData {
            let offsetPoop = OffsetPoop.make(poop, direction: Direction(direction))
            XCTAssertEqual(offsetPoop.data, data, "The data arrangement is wrong")
        }
    }
}
