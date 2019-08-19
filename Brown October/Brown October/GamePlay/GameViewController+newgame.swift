//
//  GameViewController+newgame.swift
//  Brown October
//
//  Created by Benjamin Lewis on 19/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension GameViewController: NewGameDelegate {
    func didTouchNewGame() {
        if traitCollection.horizontalSizeClass == .compact {
            resetGame()
        } else {
            coordinator?.start()
        }
    }
}
