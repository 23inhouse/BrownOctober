//
//  OffsetPoop.swift
//  Brown October
//
//  Created by Benjamin Lewis on 10/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class OffsetPoop {
    private(set) var poop: Poop
    private(set) var direction: Direction
    private(set) var data: [[Int]]
    private(set) var offset: (x: Int, y: Int) = (0, 0)
    private(set) var centerOffset: Int = 0

    static func makeRandom(_ poop: Poop) -> OffsetPoop {
        return make(poop, direction: Direction.random())
    }

    static func make(_ poop: Poop, direction: Direction) -> OffsetPoop {
        return OffsetPoop(poop, direction: direction)
    }

    static func make(_ poop: Poop, direction: Int) -> OffsetPoop {
        return make(poop, direction: Direction(direction))
    }

    fileprivate func calcOffsets() {
        var data = GridUtility.rotate(self.data, direction: direction)
        if poop.flip && [.left, .up].contains(direction.name) {
            data = GridUtility.flip(data, direction.name == .left ? .vertically : .horizontally)
        }
        self.data = data
        self.centerOffset = calcCenteOffset(data)
        self.offset = calcXYOffsets(data)
    }

    fileprivate func calcXYOffsets(_ data: [[Int]]) -> (Int, Int) {
        let rotatedWidth = self.data[0].count
        let rotatedHeight = self.data.count
        let xOffset = rotatedWidth >= rotatedHeight ? 0 : centerOffset
        let yOffset = rotatedWidth > rotatedHeight ? centerOffset : 0
        return (xOffset, yOffset)
    }

    fileprivate func calcCenteOffset(_ data: [[Int]]) -> Int {
        let largestDimension = data[0].count > data.count ? data[0].count : data.count
        return largestDimension / 2
    }

    fileprivate func calcEmptyOffset(_ data: [[Int]]) -> Int {
        var offset = 0
        for row in data {
            guard row.reduce(0, +) == 0 else { break }
            offset -= 1
        }

        return offset
    }

    init(_ poop: Poop, direction: Direction) {
        self.poop = poop
        self.direction = direction
        self.data = poop.data
        calcOffsets()
    }
}

extension OffsetPoop: RotatableProtocol {
    func rotate() -> RotatableProtocol {
        return OffsetPoop(poop, direction: direction.rotate())
    }
}

extension OffsetPoop: OffsetableProtocol {
    func xOffset() -> Int {
        return offset.x - centerOffset
    }

    func yOffset() -> Int {
        return offset.y - centerOffset
    }
}
