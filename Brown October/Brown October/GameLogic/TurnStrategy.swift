//
//  TurnStrategy.swift
//  Brown October
//
//  Created by Benjamin Lewis on 24/9/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class TurnStrategy {
    let game: Game

    weak var gameDelegate: PlayerTurnDelegate?

    static func make(playMode: PlayMode, for game: Game, with delegate: PlayerTurnDelegate) -> TurnStrategyProtocol {
        switch playMode {
        case .alternating:
            return AlternatingTurnStrategy(for: game, with: delegate)
        case .wholeBoard:
            return WholeBoardPerTurnStrategy(for: game, with: delegate)
        }
    }

    init(for game: Game, with delegate: PlayerTurnDelegate) {
        self.game = game
        self.gameDelegate = delegate
    }
}

class AlternatingTurnStrategy: TurnStrategy, TurnStrategyProtocol {
    func playMove(for player: Player, on board: Board, at index: Int, flush: (Poop) -> Void) {
        guard let poop = board.wipe(at: index) else {
            guard !game.over() else {
                gameDelegate?.gameOver(from: player)
                return
            }

            gameDelegate?.nextPlayer(after: player)
            return
        }

        if poop.isFound {
            flush(poop)
        }

        guard !game.over() else {
            gameDelegate?.gameOver(from: player)
            return
        }

        gameDelegate?.nextTurn(for: player, flushed: poop.isFound)
    }
}

class WholeBoardPerTurnStrategy: TurnStrategy, TurnStrategyProtocol {
    func playMove(for player: Player, on board: Board, at index: Int, flush: (Poop) -> Void) {
        guard let poop = board.wipe(at: index) else {
            guard !player.isGameOver else {
                endTurn(for: player)
                return
            }

            gameDelegate?.nextTurn(for: player, flushed: false)
            return
        }

        if poop.isFound {
            flush(poop)
        }

        guard !player.isGameOver else {
            endTurn(for: player)
            return
        }

        gameDelegate?.nextTurn(for: player, flushed: poop.isFound)
    }

    private func endTurn(for player: Player) {
        if player === self.gameDelegate?.firstPlayer {
            self.gameDelegate?.nextPlayer(after: player)
        } else {
            self.gameDelegate?.gameOver(from: player)
        }
    }
}
