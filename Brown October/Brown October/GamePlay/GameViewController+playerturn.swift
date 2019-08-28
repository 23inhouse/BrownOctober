//
//  GameViewController+playerturn.swift
//  Brown October
//
//  Created by Benjamin Lewis on 19/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension GameViewController: PlayerTurnDelegate {
    func show(player: Player) {
        playerController.set(player: player)
        playerController.draw()
    }

    func nextTurn(after player: Player, flushed: Bool = false) {
        show(player: player)
        guard player.isComputer else { return }

        playComputerTurn(flushed: flushed)
    }

    func nextPlayer(after player: Player) {
        show(player: player)
        playerView.boardView.isUserInteractionEnabled = false

        let delay = 1.0

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            let otherPlayer = player.isHuman ? self.computerPlayer : self.player
            self.show(player: otherPlayer)
            self.nextTurn(after: otherPlayer)
        }
    }

    func gameOver(from sender: PlayerViewController) {
        playerView.boardView.isUserInteractionEnabled = false

        sender.incrementGamesWon()

        playerView.boardView.draw(with: RevealBoardDecorator(for: playerController.board))
        playerController.showHeatSeak = false
        playerView.boardView.draw(with: HeatMapBoardDecorator(for: Board.makeGameBoard()))
        playerView.boardView.draw(with: RevealBoardDecorator(for: playerController.board))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            let won = self.player.won()
            let humanBoard = self.player.board
            let computerBoard = self.computerPlayer.board
            let winner = won ? Player.Key.human : Player.Key.computer
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
