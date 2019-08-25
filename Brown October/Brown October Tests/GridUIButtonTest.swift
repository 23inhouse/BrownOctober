//
//  GridUIButtonTest.swift
//  Brown October Tests
//
//  Created by Benjamin Lewis on 25/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import Brown_October

class GridUIButtonTest: XCTestCase {
    func testPerformance() {
        self.measure {
            for _ in 0 ..< 300 {
                _ = GridUIButton(index: 1, borderWidth: 1)
            }
        }
    }
}
