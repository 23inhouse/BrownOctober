//
//  GridUtility.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 25/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class Matrix {
    var data: [Int?] = []
    var width = 0
    var height = 0

    func print(_ title: String) {
        Swift.print("\(title) -- (\(width),\(height)) --")
        for y in 0 ..< height {
            let row = y * width
            let rowString = data[row ..< (row + width)].map { $0 == nil ? " " : String(describing: $0!)
}.joined(separator: ", ")
            Swift.print("[\(rowString)]")
        }
    }
}

class GridUtility: Equatable {
    let width: Int
    let height: Int

    static func == (lhs: GridUtility, rhs: GridUtility) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }

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
        guard direction < 4 else {
            return rotateXY(x, y, direction - 4)
        }
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
            return adjustIndex(index, direction: direction - 4, offset: offset)
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

    func captureGrid(_ gridValues: [Int?], at index: Int, size: Int) -> Matrix? {
        guard let (xCenter, yCenter) = calcXY(index) else {
            return nil
        }

        let xMin = xCenter - size
        let yMin = yCenter - size
        let xMax = xCenter + size
        let yMax = yCenter + size

        let matrix = Matrix()

        matrix.width = size * 2 - 1
        matrix.height = size * 2 - 1

        if xMin < 0 { matrix.width += xMin + 1 }
        if xMax > self.width { matrix.width -= (xMax - self.width) }
        if yMin < 0 { matrix.height += yMin + 1 }
        if yMax > self.height { matrix.height -= (yMax - self.height) }

        for (i, value) in gridValues.enumerated() {
            let (x, y) = calcXY(i)!
            if x > xMin && x < xMax && y > yMin && y < yMax {
                matrix.data.append(value)
            }
        }

        return matrix
    }

    init(w: Int, h: Int) {
        self.width = w
        self.height = h
    }
}
