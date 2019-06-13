//
//  Direction.swift
//  Brown October
//
//  Created by Benjamin Lewis on 11/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

struct Direction {
    enum Named: Int {
        case right = 0
        case down = 1
        case left = 2
        case up = 3
    }

    static let order: [Named] = [.right, .down, .left, .up]

    static func all() -> [Direction] {
        return Direction.order.map { name in Direction(name) }
    }

    static func random() -> Direction {
        return Direction(order.randomElement()!)
    }

    var name: Named
    var value: Int

    init(_ name: Named) {
        self.name = name
        self.value = Direction.order.firstIndex(of: name)!
    }

    init(_ at: Int) {
        self.name = Named(rawValue: at % 4)!
        self.value = at
    }
}

extension Direction: Equatable {
    static func == (lhs: Direction, rhs: Direction) -> Bool {
        return lhs.value == rhs.value
    }
}