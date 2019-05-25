//
//  GameOverViewControllerTests.swift
//  Brown October Tests
//
//  Created by Benjamin Lewis on 24/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import Brown_October

class GameOverViewControllerTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWinningText() {
        let player = Player("human")
        let subject = GameOverViewController()
        subject.winner = player
        _ = subject.view

        XCTAssertEqual(subject.mainView.text, "💩🏆🥈🌈", "The text is wrong")
    }

    func testLosingText() {
        let player = Player("computer")
        let subject = GameOverViewController()
        subject.winner = player
        _ = subject.view

        XCTAssertEqual(subject.mainView.text, "🧻🧴🧽🚿🍎🥦📱🖕")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
