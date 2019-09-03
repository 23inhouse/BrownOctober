//
//  GameSetupViewController+difficulty.swift
//  Brown October
//
//  Created by Benjamin Lewis on 28/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension GameSetupViewController: DifficultyDelegate {
    internal func didTouchToggleDifficulty() {
        defer {
            UserData.storeDifficultyLevel(difficultyLevel: difficultyLevel)
        }
        guard difficultyLevel < 4 else {
            difficultyLevel = 1
            return
        }
        difficultyLevel += 1
    }
}
