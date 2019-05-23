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

    static func retrieveGamesWon(for player: Player) -> Int {
        let playerKey = key(for: player)
        return defaults.integer(forKey: playerKey)
    }

    static func storeGamesWon(for player: Player, count: Int) {
        let playerKey = key(for: player)
        defaults.set(count, forKey: playerKey)
    }

    static func retrievePoopStains(for board: inout Board) -> Bool {
        if let poopStainData = defaults.array(forKey: Key.poopStains.rawValue) {
            for data in poopStainData as! [[Int]] {
                board.poopStains[data[0]] = Board.PoopStain(x: data[1], y: data[2], direction: data[3])
            }

            return true
        }

        return false
    }

    static func storePoopStains(for board: Board) {
        let data = board.poopStains.map({ [$0.key, $0.value.x, $0.value.y, $0.value.direction]})
        defaults.set(data, forKey: Key.poopStains.rawValue)
    }

    static private func key(for player: Player) -> String {
        let playerKey = player.isHuman ? Key.humanGamesWon : Key.computerGamesWon
        return playerKey.rawValue
    }
}
