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

    static private func key(for player: Player) -> String {
        let playerKey = player.isHuman ? Key.humanGamesWon : Key.computerGamesWon
        return playerKey.rawValue
    }
}
