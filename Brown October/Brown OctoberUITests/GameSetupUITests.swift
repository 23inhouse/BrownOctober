//
//  GameSetupUITests.swift
//  Brown OctoberUITests
//
//  Created by Benjamin Lewis on 25/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

class GameSetupUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false

        app.launchArguments = ["-reset", "-game-state", "setup"]
        app.launch()
    }

    override func tearDown() {
    }

    func testGameSetup() {
        app.tap()
        saveScreenshot("game-setup.png")
    }
}
