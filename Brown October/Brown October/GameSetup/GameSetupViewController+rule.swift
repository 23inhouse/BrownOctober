//
//  GameSetupViewController+rule.swift
//  Brown October
//
//  Created by Benjamin Lewis on 27/9/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension GameSetupViewController: RuleSelectionDelegate {
    internal func didTouchToggleRule() {
        gameRule = gameRule.next()
        UserData.storeGameRule(gameRule: gameRule)

        drawMode()
    }
}
