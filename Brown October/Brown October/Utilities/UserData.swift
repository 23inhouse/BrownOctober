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
        case gameRule
        case humanGamesWon
        case playMode
        case poopStains
    }

    static let defaults = UserDefaults.standard

    static func reset() {
        defaults.set(0, forKey: Key.humanGamesWon.rawValue)
        defaults.set(0, forKey: Key.computerGamesWon.rawValue)
        resetPoopStains()
        defaults.set(1, forKey: Key.difficultyLevel.rawValue)
        defaults.set(PlayMode.alternating.rawValue, forKey: Key.playMode.rawValue)
        defaults.set(PlayRule.brownOctober.rawValue, forKey: Key.gameRule.rawValue)
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

    static func retrieveGameRule() -> PlayRule {
        let gameRuleValue = defaults.integer(forKey: Key.gameRule.rawValue)
        return PlayRule(rawValue: gameRuleValue) ?? .brownOctober
    }

    static func storeGameRule(gameRule: PlayRule) {
        defaults.set(gameRule.rawValue, forKey: Key.gameRule.rawValue)
    }

    static private func key(for player: Player.Key) -> String {
        let playerKey = player == Player.Key.human ? Key.humanGamesWon : Key.computerGamesWon
        return playerKey.rawValue
    }
}
