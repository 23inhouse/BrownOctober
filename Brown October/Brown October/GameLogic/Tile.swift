//
//  Tile.swift
//  Brown October
//
//  Created by Benjamin Lewis on 18/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class Tile {

    var poopIdentifier: Int = 0
    var isFound = false
    var isFlushed = false
    var heat: Double? = nil

    func markAsFlushed() {
        isFlushed = true
    }

    func markAsFound() {
        isFound = true
    }
}
