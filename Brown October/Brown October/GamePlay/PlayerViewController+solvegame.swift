//
//  PlayerViewController+solvegame.swift
//  Brown October
//
//  Created by Benjamin Lewis on 19/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension PlayerViewController: SolveGameDelegate {
    func didTouchSolveGame() {
        guard !player.won() else { return }

        showHeatSeak.toggle()

        if showHeatSeak {
            let computerPlayer = getComputerPlayer()
            _ = computerPlayer.poopSeeker.calcRandomBestIndex(at: nil)
            boardView.draw(with: HeatMapBoardDecorator(for: computerPlayer.board))
        } else {
            boardView.draw()
        }
    }
}
