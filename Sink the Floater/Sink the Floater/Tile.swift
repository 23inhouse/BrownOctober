//
//  Tile.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 18/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class Tile {

    var x: Int
    var y: Int
    var poopIdentifier: Int
    var isFound = false
    var isFlushed = false

    func markAsFlushed() {
        isFlushed = true
    }

    func markAsFound() {
        isFound = true
    }

    init(x xPos: Int, y yPos:Int, poopIdent poopIndentifier: Int) {
        self.x = xPos
        self.y = yPos
        self.poopIdentifier = poopIndentifier
    }
}
