//
//  GameSetupViewController+play.swift
//  Brown October
//
//  Created by Benjamin Lewis on 28/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension GameSetupViewController: PlayDelegate {
    func didTouchPlayGame() {
        UserData.storePoopStains(board.poopStains)
        coordinator?.playGame()
    }
}
