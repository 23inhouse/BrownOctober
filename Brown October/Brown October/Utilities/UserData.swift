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
        case computerGamesWon
        case difficultyLevel
        case humanGamesWon
        case playMode
        case poopStains
    }

    static let defaults = UserDefaults.standard

    static func reset() {
        defaults.set(0, forKey: Key.humanGamesWon.rawValue)
        defaults.set(0, forKey: Key.computerGamesWon.rawValue)
        defaults.set([], forKey: Key.poopStains.rawValue)
        defaults.set(1, forKey: Key.difficultyLevel.rawValue)
        defaults.set(PlayMode.alternating.rawValue, forKey: Key.playMode.rawValue)
    }

    static func retrieveDifficultyLevel() -> Int {
        let difficultyLevel = defaults.integer(forKey: Key.difficultyLevel.rawValue)
        return difficultyLevel > 0 ? difficultyLevel : 1
    }

    static func storeDifficultyLevel(difficultyLevel: Int) {
        defaults.set(difficultyLevel, forKey: Key.difficultyLevel.rawValue)
    }

    static func retrieveGamesWon(for player: Player.Key) -> Int {
        let playerKey = key(for: player)
        return defaults.integer(forKey: playerKey)
    }

    static func storeGamesWon(for player: Player.Key, count: Int) {
        let playerKey = key(for: player)
        defaults.set(count, forKey: playerKey)
    }

    static func retrievePlayMode() -> PlayMode {
        let playModeValue = defaults.integer(forKey: Key.playMode.rawValue)
        return PlayMode(rawValue: playModeValue) ?? .alternating
    }

    static func storePlayMode(playMode: PlayMode) {
        defaults.set(playMode.rawValue, forKey: Key.playMode.rawValue)
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

    static private func key(for player: Player.Key) -> String {
        let playerKey = player == Player.Key.human ? Key.humanGamesWon : Key.computerGamesWon
        return playerKey.rawValue
    }
}
