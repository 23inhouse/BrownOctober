//
//  Sink the Floater.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 18/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class SinkTheFloater {

    var poops = [Poop]()
    var labelPoops = [Poop]()
    var tiles = [Tile]()
    var labelTiles = [Tile]()

    let gridUtility = GridUtility.init(w: 10, h: 10)
    let labelGridUtility = GridUtility.init(w: 15, h: 7)

    func chooseTile(at index: Int) -> Int {
        return self.tiles[index].poopIdentifier
    }

    func findPoop(at index: Int) -> Poop? {
        let indent = self.tiles[index].poopIdentifier
        if indent == 0 { return nil }
        for poop in self.poops {
            if poop.identifier == indent {
                return poop
            }
        }

        return nil
    }

    init() {
        setUpGrid()
        setUpLabels()
    }

    private func setUpGrid() {
        self.poops = Poop.pinchSomeOff()

        for y in 0 ..< gridUtility.height {
            for x in 0 ..< gridUtility.width {
                let tile = Tile(x: x, y: y, poopIdent: 0)
                self.tiles.append(tile)
            }
        }

        for poop in self.poops.reversed() {
            var placementRequired = true

            while placementRequired {

                let x = Int(arc4random_uniform(UInt32(gridUtility.width)))
                let y = Int(arc4random_uniform(UInt32(gridUtility.width)))
                let direction = Int(arc4random_uniform(4))

                placementRequired = !placePoop(poop, x: x, y: y, direction: direction, labels: false)
            }
        }
    }

    private func setUpLabels() {
        self.labelPoops = Poop.pinchSomeOff()

        for y in 0 ..< labelGridUtility.height {
            for x in 0 ..< labelGridUtility.width {
                let tile = Tile(x: x, y: y, poopIdent: 0)
                self.labelTiles.append(tile)
            }
        }

        _ = placePoop(self.labelPoops[0], x: 1, y: 5, direction: 3, labels: true, check: false)
        _ = placePoop(self.labelPoops[1], x: 3, y: 5, direction: 3, labels: true, check: false)
        _ = placePoop(self.labelPoops[2], x: 5, y: 3, direction: 1, labels: true, check: false)
        _ = placePoop(self.labelPoops[3], x: 8, y: 5, direction: 3, labels: true, check: false)
        _ = placePoop(self.labelPoops[4], x: 10, y: 5, direction: 3, labels: true, check: false)
        _ = placePoop(self.labelPoops[5], x: 12, y: 2, direction: 1, labels: true, check: false)
    }

    private func placePoop(_ poop: Poop, x:Int, y:Int, direction:Int, labels: Bool, check: Bool? = true) -> Bool {

        let gUtility = labels ? labelGridUtility : gridUtility
        let data = GridUtility.rotate(poop.data, times: direction)

        for (yIndex, values) in data.enumerated() {
            for (xIndex, value) in values.enumerated() {

                guard value == 1 else { continue }

                guard let (xAdjust, yAdjust) = GridUtility.rotateXY(xIndex, yIndex, direction) else {
                    return false
                }

                guard let index = gUtility.calcIndex(x + xAdjust, y + yAdjust) else {
                    return false
                }

                if check! == true {
                    if !checkAdjacentTiles(index) { return false }
                    continue
                }

                if labels {
                    self.labelTiles[index].poopIdentifier = poop.identifier
                } else {
                    self.tiles[index].poopIdentifier = poop.identifier
                }
            }
        }

        if check! == true {
            return placePoop(poop, x: x, y: y, direction: direction, labels: labels, check: false)
        }

        return true
    }

    private func checkAdjacentTiles(_ index: Int) -> Bool {
        if self.tiles[index].poopIdentifier > 0 { return false }

        for direction in 0 ..< 4 {
            guard let index = gridUtility.adjustIndex(index, direction: direction, offset: 1) else {
                continue
            }

            if self.tiles[index].poopIdentifier > 0 { return false }
        }
        return true
    }
}
