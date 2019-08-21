//
//  GameViewController+playerturn.swift
//  Brown October
//
//  Created by Benjamin Lewis on 19/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension GameViewController: PlayerTurnDelegate {
    func gameOver(from sender: PlayerViewController) {
        playerTwoView.boardView.isUserInteractionEnabled = false

        sender.incrementGamesWon()

        playerOneView.boardView.draw(with: RevealBoardDecorator(for: playerOneController.board))
        playerTwoController.showHeatSeak = false
        playerTwoView.boardView.draw(with: HeatMapBoardDecorator(for: Board.makeGameBoard()))
        playerTwoView.boardView.draw(with: RevealBoardDecorator(for: playerTwoController.board))

        if traitCollection.horizontalSizeClass == .compact {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                let won = self.playerTwo.won()
                let humanBoard = self.playerTwo.board
                let computerBoard = self.playerOne.board
                let winner = won ? Player.Key.human : Player.Key.computer
                self.coordinator?.gameOver(winner: winner, humanBoard: humanBoard, computerBoard: computerBoard)
            }
        }
    }

    func nextTurn(from sender: PlayerViewController, switchPlayer: Bool) {
        let player = sender.player
        let playerView = sender.playerView

        if switchPlayer == player.isHuman {
            playerView.boardView.isUserInteractionEnabled = false
        }

        let delay = player.isHuman ? 0.05 : 0.5

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            if switchPlayer {
                self.showOther(playerView: playerView)
            }

            let delay = self.turnDelay(switchPlayer)

            if switchPlayer == player.isHuman {
                self.playComputerTurn(delay: delay)
            }
        }
    }

    private func showOther(playerView: PlayerUIView) {
        let otherPlayerView = playerView.player.isHuman ? self.playerOneController.playerView : self.playerTwoController.playerView
        otherPlayerView.boardView.isUserInteractionEnabled = true

        guard traitCollection.horizontalSizeClass == .compact else { return }

        otherPlayerView.isHidden = false
        playerView.isHidden = true
    }

    private func turnDelay(_ switchPlayer: Bool) -> Double {
        let normal: Double = 0.25
        let switching: Double = 0.75

        guard traitCollection.horizontalSizeClass == .compact else { return normal }
        guard switchPlayer else { return normal }

        return switching
    }

    private func playComputerTurn(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            let computerPlayer = self.playerOneController.getComputerPlayer()
            computerPlayer.playNext()
        }
    }
}
