//
//  UserData+poopStains.swift
//  Brown October
//
//  Created by Benjamin Lewis on 28/9/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension UserData {
    static func retrievePoopStains() -> [Int: Board.PoopStain] {
        let gameRule = UserData.retrieveGameRule()

        var poopStains = [Int: Board.PoopStain]()

        guard let poopStainData = defaults.array(forKey: Key.poopStains.rawValue) else { return poopStains }
        guard poopStainData.count > 0 else { return poopStains }

        for data in poopStainData as! [[Int]] {
            guard PlayRule(rawValue: data[0]) == gameRule else { continue }
            guard data.count == 5 else { continue }
            poopStains[data[1]] = Board.PoopStain(x: data[2], y: data[3], direction: Direction(data[4]))
        }

        return poopStains
    }

    static func storePoopStains(_ poopStains: [Int: Board.PoopStain]) {
        let gameRule = UserData.retrieveGameRule()

        var poopStainsData: [[Int]] = defaults.array(forKey: Key.poopStains.rawValue) as? [[Int]] ?? [[Int]]()
        poopStains.forEach { (ident, poopStain) in
            let data = [gameRule.rawValue, ident, poopStain.x, poopStain.y, poopStain.direction.value]
            if let index = poopStainsData.firstIndex(where: { data in data[0] == gameRule.rawValue && data[1] == ident }) {
                poopStainsData[index] = data
            } else {
                poopStainsData.append(data)
            }

        }
        defaults.set(poopStainsData, forKey: Key.poopStains.rawValue)
    }

    static func resetPoopStains() {
        defaults.set([], forKey: Key.poopStains.rawValue)
    }
}
