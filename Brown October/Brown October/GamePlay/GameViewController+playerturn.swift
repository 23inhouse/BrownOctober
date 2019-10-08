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
            playerController.boardView.flush(ident: poop.identifier)
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

    func highlightScore(for player: Player, completion: @escaping (Player) -> Void) {
        playerView.boardView.isUserInteractionEnabled = false
        show(player: player)
        highlightScore(true)

        let delay = 3.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.highlightScore(false)
            completion(player)
        }
    }

    func gameOver(from player: Player) {
        guard game.over() else { return }
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
        let delay: Double = flushed ? 1.0 : 0.25
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.playerController.getComputerPlayer().playNext()
        }
    }
}
