//
//  GridUtility.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 25/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class GridUtility {
    let width: Int
    let height: Int

    static func rotate(_ matrix: [[Int]], times: Int) -> [[Int]] {
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

    static func rotateXY(_ x: Int, _ y: Int, _ direction: Int) -> (Int, Int)? {
        var xAdjust: Int
        var yAdjust: Int

        switch(direction) {
        case 2:
            xAdjust = -1 * x
            yAdjust = 1 * y
        case 3:
            xAdjust = 1 * x
            yAdjust = -1 * y
        default:
            xAdjust = 1 * x
            yAdjust = 1 * y
        }

        return (xAdjust, yAdjust)
    }

    func adjustIndex(_ index: Int, direction: Int, offset: Int) -> Int? {
        guard let (x, y) = calcXY(index) else { return nil }

        var newIndex: Int?

        switch direction {
        case 0:
            newIndex = calcIndex(x + offset, y)
        case 1:
            newIndex = calcIndex(x, y + offset)
        case 2:
            newIndex = calcIndex(x - offset, y)
        case 3:
            newIndex = calcIndex(x, y - offset)
        default:
            return nil
        }

        return newIndex
    }

    func calcXY(_ index: Int) -> (Int, Int)? {
        guard index >= 0 && index < self.width * self.height else { return nil }

        let x = index % self.width
        let y = (index - x) / self.width
        return (x, y)
    }

    func calcIndex(_ x: Int, _ y: Int) -> Int? {
        guard x >= 0 && x < self.width else { return nil }
        guard y >= 0 && y < self.height else { return nil }

        return y * self.width + x
    }

    init(w: Int, h: Int) {
        self.width = w
        self.height = h
    }
}
