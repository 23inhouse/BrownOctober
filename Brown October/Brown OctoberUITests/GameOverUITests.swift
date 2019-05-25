//
//  GameOverUITests.swift
//  Brown OctoberUITests
//
//  Created by Benjamin Lewis on 24/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

class GameOverUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false

        app.launchArguments = ["-reset", "-game-state", "over"]
        app.launch()
    }

    func testGameOver() {
        app.tap()
        saveScreenshot("game-over.png")
    }

}
