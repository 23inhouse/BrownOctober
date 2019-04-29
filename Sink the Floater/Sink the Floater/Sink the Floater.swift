//
//  Sink the Floater.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 18/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class Game {
    let gridUtility: GridUtility

    var poops = [Poop]()
    var tiles = [Tile]()
    var score = 0

    func createGrid(tiles: inout [Tile], utility: GridUtility) {

        for y in 0 ..< utility.height {
            for x in 0 ..< utility.width {
                let tile = Tile(x: x, y: y, poopIdent: 0)
                tiles.append(tile)
            }
        }

    }

    func gameOver() -> Bool {
        for poop in poops {
            if !poop.isFound {
                return false
            }
        }

        return true
    }

    func placePoop(_ poop: Poop, x:Int, y:Int, direction:Int, tiles: inout [Tile], utility: GridUtility, check: Bool? = true) -> Bool {

        let data = GridUtility.rotate(poop.data, times: direction)

        for (yIndex, values) in data.enumerated() {
            for (xIndex, value) in values.enumerated() {

                guard value == 1 else { continue }

                guard let (xAdjust, yAdjust) = GridUtility.rotateXY(xIndex, yIndex, direction) else {
                    return false
                }

                guard let index = utility.calcIndex(x + xAdjust, y + yAdjust) else {
                    return false
                }

                if check! == true {
                    if !checkAdjacentTiles(tiles: tiles, index: index) { return false }
                    continue
                }

                tiles[index].poopIdentifier = poop.identifier
            }
        }

        if check! == true {
            return placePoop(poop, x: x, y: y, direction: direction, tiles: &tiles, utility: utility, check: false)
        }

        return true
    }

    func wipe(at index: Int) -> (Tile, Poop)? {
        if let (tile, poop) = findData(tiles: &self.tiles, at: index) {
            guard !tile.isFound else {
                return nil
            }
            score += 1
            tile.markAsFound()
            poop.incrementFoundCounter()

            return (tile, poop)
        }

        return nil
    }

    init(width: Int, height: Int) {
        self.gridUtility = GridUtility.init(w: width, h: height)
    }

    private func checkAdjacentTiles(tiles: [Tile], index: Int) -> Bool {
        if tiles[index].poopIdentifier > 0 { return false }

        for direction in 0 ..< 4 {
            guard let index = gridUtility.adjustIndex(index, direction: direction, offset: 1) else {
                continue
            }

            if tiles[index].poopIdentifier > 0 { return false }
        }
        return true
    }

    private func findData(tiles: inout [Tile], at index: Int) -> (Tile, Poop)? {

        let tile = tiles[index]
        let indent = tile.poopIdentifier

        guard indent != 0 else { return nil }

        for poop in self.poops {
            if poop.identifier == indent {
                return (tile, poop)
            }
        }

        return nil
    }
}

class SinkTheFloater: Game {
    let labelGridUtility = GridUtility.init(w: 15, h: 7)

    var labelPoops = [Poop]()
    var labelTiles = [Tile]()

    init() {
        super.init(width: 10, height: 10)

        setUpGridWithRandomPoops()
        setUpLabels()
    }

    private func setUpGridWithRandomPoops() {
        self.poops = Poop.pinchSomeOff()

        createGrid(tiles: &self.tiles, utility: self.gridUtility)

        for poop in self.poops.reversed() {
            var placementRequired = true

            while placementRequired {

                let x = Int(arc4random_uniform(UInt32(gridUtility.width)))
                let y = Int(arc4random_uniform(UInt32(gridUtility.width)))
                let direction = Int(arc4random_uniform(4))

                placementRequired = !placePoop(poop, x: x, y: y, direction: direction, tiles: &self.tiles, utility: gridUtility)
            }
        }
    }

    private func setUpLabels() {
        self.labelPoops = Poop.pinchSomeOff()

        createGrid(tiles: &self.labelTiles, utility: self.labelGridUtility)

        _ = placePoop(self.labelPoops[0], x: 1, y: 5, direction: 3, tiles: &self.labelTiles, utility: labelGridUtility, check: false)
        _ = placePoop(self.labelPoops[1], x: 3, y: 5, direction: 3, tiles: &self.labelTiles, utility: labelGridUtility, check: false)
        _ = placePoop(self.labelPoops[2], x: 5, y: 3, direction: 1, tiles: &self.labelTiles, utility: labelGridUtility, check: false)
        _ = placePoop(self.labelPoops[3], x: 8, y: 5, direction: 3, tiles: &self.labelTiles, utility: labelGridUtility, check: false)
        _ = placePoop(self.labelPoops[4], x: 10, y: 5, direction: 3, tiles: &self.labelTiles, utility: labelGridUtility, check: false)
        _ = placePoop(self.labelPoops[5], x: 12, y: 2, direction: 1, tiles: &self.labelTiles, utility: labelGridUtility, check: false)
    }
}
