//
//  GameSetupViewController+mode.swift
//  Brown October
//
//  Created by Benjamin Lewis on 28/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension GameSetupViewController: ModeSelectionDelegate {
    internal func didTouchToggleMode() {
        modeButton.isUserInteractionEnabled = false

        playMode = playMode.next()
        UserData.storePlayMode(playMode: playMode)

        switch playMode {
        case .alternating:
            boardView.isUserInteractionEnabled = true
            modeButton.isUserInteractionEnabled = true
            boardView.draw()
        case .wholeBoard:
            boardView.isUserInteractionEnabled = false
            flashShuffle { [weak self] in
                self?.modeButton.isUserInteractionEnabled = true
            }
        }
    }

    private func flashShuffle(remaining: Int = 10, completion: (() -> Void)? = nil) {
        guard remaining > 0 else {
            boardView.draw(with: WaveBoardDecorator(for: Board.makeGameBoard(), even: remaining % 2 == 0))
            completion?()
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (0.05 * Double(remaining))) { [weak self] in
            let tempBoard: Board = Board.makeGameBoard()
            tempBoard.arrangePoops(reset: true)
            self?.boardView.draw(with: ArrangeBoardDecorator(for: tempBoard))

            self?.flashShuffle(remaining: remaining - 1, completion: completion)
        }
    }
}
