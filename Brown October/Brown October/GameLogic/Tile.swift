//
//  Tile.swift
//  Brown October
//
//  Created by Benjamin Lewis on 18/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class Tile {

    private(set) var poopIdentifier: Int = 0
    private(set) var isFound = false
    private(set) var isFlushed = false
    private(set) var heat: Double? = nil

    func markAsFlushed() {
        isFlushed = true
    }

    func markAsFound() {
        isFound = true
    }

    func set(heat: Double) {
        self.heat = heat
    }

    func set(identifier: Int) {
        poopIdentifier = identifier
    }
}
