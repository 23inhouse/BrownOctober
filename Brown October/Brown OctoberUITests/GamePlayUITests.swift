//
//  GamePlayUITests.swift
//  Brown OctoberUITests
//
//  Created by Benjamin Lewis on 26/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

class GamePlayUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false

        app.launchArguments = ["-reset", "-game-state", "play"]
        app.launch()
    }

    func testGameSetup() {
        saveScreenshot("game-play.png")
    }
}
