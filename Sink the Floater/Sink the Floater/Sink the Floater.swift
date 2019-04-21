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

    var indexOfOneAndOnlyFaceUpCard: Int?

    var flipCount = 0

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

        for y in 0 ..< 10 {
            for x in 0 ..< 10 {
                let tile = Tile(x: x, y: y, poopIdent: 0)
                self.tiles.append(tile)
            }
        }

        for poop in self.poops {
            var placementRequired = true

            while placementRequired {

                let x = Int(arc4random_uniform(10))
                let y = Int(arc4random_uniform(10))
                let direction = Int(arc4random_uniform(4))

                placementRequired = !placePoop(poop, x: x, y: y, direction: direction, labels: false)
            }
        }
    }

    private func setUpLabels() {
        self.labelPoops = Poop.pinchSomeOff()

        for y in 0 ..< 7 {
            for x in 0 ..< 15 {
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

    func placePoop(_ poop: Poop, x:Int, y:Int, direction:Int, labels: Bool, check: Bool? = true) -> Bool {

        var xMult: Int
        var yMult: Int

        let xWidth = labels ? 15 : 10

        let data = rotate(poop.data, times: direction)

        for (yIndex, values) in data.enumerated() {
            for (xIndex, value) in values.enumerated() {
                if value != 1 { continue }

                switch(direction) {
                case 2:
                    xMult = -1 * xIndex
                    yMult = 1 * yIndex
                case 3:
                    xMult = 1 * xIndex
                    yMult = -1 * yIndex
                default:
                    xMult = 1 * xIndex
                    yMult = 1 * yIndex
                }

                let tileX = x + xMult
                let tileY = y + yMult

                let index = tileY * xWidth + tileX

                if check! {
                    let xBound = x + xMult
                    let yBound = y + yMult

                    if xBound < 0 || xBound > 9 { return false }
                    if yBound < 0 || yBound > 9 { return false }

                    if labels {
                        if self.labelTiles[index].poopIdentifier > 0 { return false }
                    } else {
                        if self.tiles[index].poopIdentifier > 0 { return false }
                    }
                } else {
                    if labels {
                        self.labelTiles[index].poopIdentifier = poop.identifier
                    } else {
                        self.tiles[index].poopIdentifier = poop.identifier
                    }
              }
            }
        }

        if check! {
            return placePoop(poop, x: x, y: y, direction: direction, labels: labels, check: false)
        }

        return true
    }

    func rotate(_ matrix: [[Int]], times: Int) -> [[Int]] {
        if times == 0 { return matrix }

        let x = matrix.count
        let y = matrix[0].count

        let z = [Int](repeating: 0, count: x)
        var newMatrix = [[Int]](repeating: z, count: y)

        for i in 0 ..< x {
            for j in 0 ..< y {
                newMatrix[j][i] = matrix[x - i - 1][j]
            }
        }

        return rotate(newMatrix, times: times - 1)
    }
}
