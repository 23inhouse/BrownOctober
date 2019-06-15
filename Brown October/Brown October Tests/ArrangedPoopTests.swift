//
//  ArrangedPoopTests.swift
//  Brown October Tests
//
//  Created by Benjamin Lewis on 14/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

@testable import Brown_October

class ArrangedPoopTests: XCTestCase {
    func testInit() {
        let board = TestBoardHelper.makeBoard(width: 2, height: 2)

        let poop1 = Poop.poop1()
        let poop2 = Poop.poop2()
        board.addPoopStain(poop2, x: 0, y: 0, direction: Direction(0))

        let expectations:[(Poop, Direction?, Bool)] = [
            (poop1, nil, false),
            (poop1, Direction(0), true),
            (poop2, nil, true),
            (poop2, Direction(1), true),
        ]

        for (poop, direction, bool) in expectations {
            let arrangedPoop = ArrangedPoop(poop, board, direction: direction)
            XCTAssertEqual(arrangedPoop != nil, bool, "The arranged poop should exist \(bool) is wrong")
        }
    }

    func testMoveBy() {
        let board = TestBoardHelper.makeBoard(width: 3, height: 3)
        let poop = Poop.poop1()
        let offsetPoop = OffsetPoop.make(poop, direction: Direction(.right))
        let arrangedPoop = ArrangedPoop(offsetPoop, board)

        let expectations:[((Int, Int), Bool)] = [
            ((1, 1), true),
            ((-1, -1), false),
        ]

        for (adjustment, bool) in expectations {
            _ = arrangedPoop.place(at: (1, 1))
            let moved = arrangedPoop.move(by: adjustment)
            XCTAssertEqual(moved, bool, "The poop should fit? \(bool)")
        }
    }

    func testMoveTo() {
        let board = TestBoardHelper.makeBoard(width: 3, height: 3)
        let poop = Poop.poop1()
        let offsetPoop = OffsetPoop.make(poop, direction: Direction(.right))
        let arrangedPoop = ArrangedPoop(offsetPoop, board)
        _ = arrangedPoop.place(at: 4)

        let expectations:[(Int, Bool)] = [
            (8, true),
            (0, false),
        ]

        for (index, bool) in expectations {
            let moved = arrangedPoop.move(to: index)
            XCTAssertEqual(moved, bool, "The poop should fit? \(bool)")
        }
    }

    func testPlaceAtCoordinate() {
        let board = TestBoardHelper.makeBoard(width: 2, height: 2)
        let poop = Poop.poop1()
        let offsetPoop = OffsetPoop.make(poop, direction: Direction(.right))

        let expectations:[(OffsetPoop, (Int, Int), Bool)] = [
            (offsetPoop, (1, 1), true),
            (offsetPoop, (0, 0), false),
        ]

        for (offsetPoop, coordinate, bool) in expectations {
            board.set(poopStains: [Int:Board.PoopStain]())
            let arrangedPoop = ArrangedPoop(offsetPoop, board)
            let placed = arrangedPoop.place(at: coordinate)
            let poopStain = board.poopStains.first
            XCTAssertEqual(placed, bool, "The poop should fit? \(bool)")
            XCTAssertEqual(poopStain != nil, bool, "The poopStain should exist? \(bool)")
        }
    }

    func testPlaceAtIndex() {
        let board = TestBoardHelper.makeBoard(width: 2, height: 2)
        let poop = Poop.poop1()
        let offsetPoop = OffsetPoop.make(poop, direction: Direction(.right))

        let expectations:[(OffsetPoop, Int, Bool)] = [
            (offsetPoop, 3, true),
            (offsetPoop, 0, false),
        ]

        for (offsetPoop, index, bool) in expectations {
            board.set(poopStains: [Int:Board.PoopStain]())
            let arrangedPoop = ArrangedPoop(offsetPoop, board)
            let placed = arrangedPoop.place(at: index)
            let poopStain = board.poopStains.first
            XCTAssertEqual(placed, bool, "The poop should fit? \(bool)")
            XCTAssertEqual(poopStain != nil, bool, "The poopStain should exist? \(bool)")
        }
    }

    func testRotate() {
        let board1 = TestBoardHelper.makeBoard(width: 2, height: 2)
        let board2 = TestBoardHelper.makeBoard(width: 2, height: 1)
        let poop = Poop.poop1()
        let offsetPoop = OffsetPoop.make(poop, direction: Direction(.right))

        let expectations:[(Board, OffsetPoop, Bool)] = [
            (board1, offsetPoop, true),
            (board2, offsetPoop, false),
        ]

        for (board, offsetPoop, bool) in expectations {
            board.addPoopStain(offsetPoop.poop, x: 1, y: 1, direction: offsetPoop.direction)
            let arrangedPoop = ArrangedPoop(offsetPoop, board)
            let rotated = arrangedPoop.rotate()
            XCTAssertEqual(rotated, bool, "The poop should rotate? \(bool)")
        }
    }
}
