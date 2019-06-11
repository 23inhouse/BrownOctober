//
//  DirectedPoop.swift
//  Brown October
//
//  Created by Benjamin Lewis on 10/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol RotatableProtocol {
    var direction: Int { get }
    func rotate() -> RotatableProtocol
}

class DirectedPoop {
    var poop: Poop
    var data = [[Int]]()
    var offset: (x: Int, y: Int) = (0, 0)
    var centerOffset: Int = 0

    static func makeRandom(_ poop: Poop) -> DirectedPoop {
        let direction = Int(arc4random_uniform(4))
        return make(poop, direction: direction)
    }

    static func make(_ poop: Poop, direction: Int) -> DirectedPoop {
        switch direction {
        case 0:
            return PoopRight(poop)
        case 1:
            return PoopDown(poop)
        case 2:
            return PoopLeft(poop)
        case 3:
            return PoopUp(poop)
        default:
            return PoopRight(poop)
        }
    }

    fileprivate func calcOffsets(_ data: [[Int]], direction: Int) {
        self.data = GridUtility.rotate(data, times: direction)
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
    var direction = 0

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
    var direction = 1

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
    var direction = 2

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
    var direction = 3

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
