//
//  GameViewController+playerturn.swift
//  Brown October
//
//  Created by Benjamin Lewis on 19/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension GameViewController: PlayerTurnDelegate {
    func playMove(_ player: Player, on board: Board, at index: Int, success: (Poop) -> Void) {
        guard !player.isGameOver else { return }

        var mover = TurnStrategy.make(playMode: playMode, for: player, on: board, at: index)
        mover.gameDelegate = self

        mover.playMove { poop in
            if gameRule == .russian {
                board.flush(by: poop.identifier, russian: true)
            }
            success(poop)
        }
    }

    func nextTurn(for player: Player, flushed: Bool = false) {
        show(player: player)
        guard player.isComputer else { return }

        playComputerTurn(flushed: flushed)
    }

    func nextPlayer(after player: Player) {
        show(player: player)
        playerView.boardView.isUserInteractionEnabled = false

        let changePlayerDelay = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + changePlayerDelay) { [weak self] in
            guard let self = self else { return }
            let otherPlayer = player.isHuman ? self.computerPlayer : self.player
            self.nextTurn(for: otherPlayer)
        }
    }

    func gameOver() {
        playerView.boardView.isUserInteractionEnabled = false

        if let winner = self.game.winner() {
            playerController.incrementGamesWon(for: winner)
        }

        playerController.showHeatSeak = false
        playerView.boardView.draw(with: HeatMapBoardDecorator(for: Board.makeGameBoard()))
        playerView.boardView.draw(with: RevealBoardDecorator(for: playerController.board))

        let gameOverDelay = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + gameOverDelay) { [weak self] in
            guard let self = self else { return }
            let humanBoard = self.player.board
            let computerBoard = self.computerPlayer.board
            let winner = self.game.winner()?.key
            self.coordinator?.gameOver(winner: winner, humanBoard: humanBoard, computerBoard: computerBoard)
        }
    }

    private func playComputerTurn(flushed: Bool) {
        let delay: Double = flushed ? 1.0 : 0.25
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.playerController.getComputerPlayer().playNext()
        }
    }
}
