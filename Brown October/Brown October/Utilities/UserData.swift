//
//  UserData.swift
//  Brown October
//
//  Created by Benjamin Lewis on 22/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

struct UserData {
    enum Key: String {
        case computerGamesWon = "computerGamesWon"
        case humanGamesWon = "humanGamesWon"
        case poopStains = "poopStains"
    }

    static let defaults = UserDefaults.standard

    static func reset() {
        defaults.set(0, forKey: Key.humanGamesWon.rawValue)
        defaults.set(0, forKey: Key.computerGamesWon.rawValue)
        defaults.set([], forKey: Key.poopStains.rawValue)
    }

    static func retrieveGamesWon(for player: Player.key) -> Int {
        let playerKey = key(for: player)
        return defaults.integer(forKey: playerKey)
    }

    static func storeGamesWon(for player: Player.key, count: Int) {
        let playerKey = key(for: player)
        defaults.set(count, forKey: playerKey)
    }

    static func retrievePoopStains() -> [Int: Board.PoopStain] {
        var poopStains = [Int: Board.PoopStain]()

        guard let poopStainData = defaults.array(forKey: Key.poopStains.rawValue) else { return poopStains }
        guard poopStainData.count > 0 else { return poopStains }

        for data in poopStainData as! [[Int]] {
            poopStains[data[0]] = Board.PoopStain(x: data[1], y: data[2], direction: Direction(data[3]))
        }

        return poopStains
    }

    static func storePoopStains(_ poopStains: [Int: Board.PoopStain]) {
        let data = poopStains.map({ (ident, poopStain) in [ident, poopStain.x, poopStain.y, poopStain.direction.value]})
        defaults.set(data, forKey: Key.poopStains.rawValue)
    }

    static private func key(for player: Player.key) -> String {
        let playerKey = player == Player.key.human ? Key.humanGamesWon : Key.computerGamesWon
        return playerKey.rawValue
    }
}
