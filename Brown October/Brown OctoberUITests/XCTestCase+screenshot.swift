//
//  XCTestCase+screenshot.swift
//  Brown October
//
//  Created by Benjamin Lewis on 25/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest

extension XCTestCase {
    func saveScreenshot(_ fileName: String = "output.png") {
        let image = XCUIScreen.main.screenshot().image
        guard let data = image.pngData() else {
            print("Error: No Screenshot data")
            return
        }
        guard FileManager.default.createFile(atPath: "/Users/ben/Pictures/\(fileName)", contents: data, attributes: nil) else {
            print("Error: Couldn't save the screenshot")
            return
        }
    }
}
