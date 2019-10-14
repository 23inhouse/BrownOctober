//
//  GameViewController+playerturn.swift
//  Brown October
//
//  Created by Benjamin Lewis on 19/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension GameViewController: PlayerTurnDelegate {
    func playMove(for player: Player, on board: Board, at index: Int) {
        let mover = TurnStrategy.make(playMode: playMode, for: game, with: self)
        mover.playMove(for: player, on: board, at: index) { poop in
            if gameRule == .russian {
                board.flush(by: poop.identifier, russian: true)
            }
            playerController.poopView.flush(ident: poop.identifier)
            playerController.foundPoopsBoard.flush(by: poop.identifier)
            playerController.poopView.draw()

            guard playMode != .wholeBoard && !player.isComputer else { return }
            playerController.boardView.flush(ident: poop.identifier)
        }
    }

    func nextTurn(for player: Player, flushed: Bool = false) {
        guard !player.isGameOver else {
            gameOver(from: player)
            return
        }

        show(player: player)

        guard player.isComputer else { return }

        playComputerTurn(flushed: flushed)
    }

    func nextPlayer(after player: Player) {
        show(player: player)
        playerView.boardView.isUserInteractionEnabled = false

        let changePlayerDelay = playMode == .wholeBoard ? 0.0 : 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + changePlayerDelay) { [weak self] in
            guard let self = self else { return }
            let otherPlayer = player.isHuman ? self.computerPlayer : self.player
            if self.playMode == .wholeBoard && player === self.firstPlayer {
                self.playerController.initialRemainingFlushCount = player.board.misses
            }
            self.nextTurn(for: otherPlayer)
        }
    }

    func gameOver(from player: Player) {
        show(player: player)

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
        let delay = computerTurnDelay(flushed: flushed)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.playerController.getComputerPlayer().playNext()
        }
    }

    private func computerTurnDelay(flushed: Bool) -> Double {
        let alternatingDelay = flushed ? 1.0 : 0.25
        switch playMode {
        case .alternating:
            return alternatingDelay
        case .wholeBoard:
            return 0.0
        }
    }
}
