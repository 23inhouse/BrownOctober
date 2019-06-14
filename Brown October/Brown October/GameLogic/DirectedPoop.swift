//
//  DirectedPoop.swift
//  Brown October
//
//  Created by Benjamin Lewis on 10/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol RotatableProtocol {
    var direction: Direction { get }
    func rotate() -> RotatableProtocol
}

class DirectedPoop {
    private(set) var poop: Poop
    private(set) var data = [[Int]]()
    private(set) var offset: (x: Int, y: Int) = (0, 0)
    private(set) var centerOffset: Int = 0

    static func makeRandom(_ poop: Poop) -> DirectedPoop {
        return make(poop, direction: Direction.random())
    }

    static func make(_ poop: Poop, direction: Direction) -> DirectedPoop {
        switch direction.name {
        case .right:
            return PoopRight(poop)
        case .down:
            return PoopDown(poop)
        case .left:
            return PoopLeft(poop)
        case .up:
            return PoopUp(poop)
        }
    }

    static func make(_ poop: Poop, direction: Int) -> DirectedPoop {
        return make(poop, direction: Direction(direction))
    }

    fileprivate func calcOffsets(_ data: [[Int]], direction: Direction) {
        var data = GridUtility.rotate(data, direction: direction)
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

    init(_ poop: Poop) {
        self.poop = poop
    }
}

class PoopRight: DirectedPoop {
    var direction = Direction(.right)

    override init(_ poop: Poop) {
        super.init(poop)
        calcOffsets(poop.data, direction: direction)
    }
}

extension PoopRight: RotatableProtocol {
    func rotate() -> RotatableProtocol {
        return PoopDown(poop)
    }
}

class PoopDown: DirectedPoop {
    var direction = Direction(.down)

    override init(_ poop: Poop) {
        super.init(poop)
        calcOffsets(poop.data, direction: direction)
    }
}

extension PoopDown: RotatableProtocol {
    func rotate() -> RotatableProtocol {
        return PoopLeft(poop)
    }
}

class PoopLeft: DirectedPoop {
    var direction = Direction(.left)

    override init(_ poop: Poop) {
        super.init(poop)
        calcOffsets(poop.data, direction: direction)
    }
}

extension PoopLeft: RotatableProtocol {
    func rotate() -> RotatableProtocol {
        return PoopUp(poop)
    }
}

class PoopUp: DirectedPoop {
    var direction = Direction(.up)

    override init(_ poop: Poop) {
        super.init(poop)
        calcOffsets(poop.data, direction: direction)
    }
}

extension PoopUp: RotatableProtocol {
    func rotate() -> RotatableProtocol {
        return PoopRight(poop)
    }
}
