//
//  DirectedPoopTests.swift
//  Brown October Tests
//
//  Created by Benjamin Lewis on 10/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

@testable import Brown_October

class DirectedPoopTests: XCTestCase {
    func testMake() {
        let poop = Poop.poop1()
        let expectedPoops:[Int:String] = [
            0: String(describing: PoopRight(poop)),
            1: String(describing: PoopDown(poop)),
            2: String(describing: PoopLeft(poop)),
            3: String(describing: PoopUp(poop)),
        ]

        for (direction, expectedPoop) in expectedPoops {
            let directedPoop = DirectedPoop.make(poop, direction: direction)
            XCTAssertEqual(String(describing: directedPoop.self), expectedPoop, "The direction \(direction) is wrong")
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
            let directedPoop = DirectedPoop.make(poop, direction: direction)
            let centerOffset = directedPoop.centerOffset
            let offset = directedPoop.offset
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
            let directedPoop = DirectedPoop.make(poop, direction: direction)
            let centerOffset = directedPoop.centerOffset
            let offset = directedPoop.offset
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
            let directedPoop = DirectedPoop.make(poop, direction: direction)
            let centerOffset = directedPoop.centerOffset
            let offset = directedPoop.offset
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
            let directedPoop = DirectedPoop.make(poop, direction: direction)
            let centerOffset = directedPoop.centerOffset
            let offset = directedPoop.offset
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
            let directedPoop = DirectedPoop.make(poop, direction: direction)
            let centerOffset = directedPoop.centerOffset
            let offset = directedPoop.offset
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
            let directedPoop = DirectedPoop.make(poop, direction: direction)
            let centerOffset = directedPoop.centerOffset
            let offset = directedPoop.offset
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
            let directedPoop = DirectedPoop.make(poop, direction: Direction(direction))
            XCTAssertEqual(directedPoop.data, data, "The data arrangement is wrong")
        }
    }
}
