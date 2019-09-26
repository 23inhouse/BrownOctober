//
//  TurnStrategy.swift
//  Brown October
//
//  Created by Benjamin Lewis on 24/9/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class TurnStrategy {
    let player: Player
    let board: Board
    let index: Int
    weak var gameDelegate: PlayerTurnDelegate?

    static func make(playMode: PlayMode, for player: Player, on board: Board, at index: Int) -> TurnStrategyProtocol {
        switch playMode {
        case .alternating:
            return AlternatingTurnStrategy(player: player, board: board, index: index)
        case .wholeBoard:
            return WholeBoardPerTurnStrategy(player: player, board: board, index: index)
        }
    }

    internal func playMove(success: (Poop) -> Void, failure: (Player) -> Void, completed: (Player) -> Void) {
        guard let poop = board.wipe(at: index) else {
            failure(player)

            if player.lost() {
                completed(player)
            }
            return
        }

        if poop.isFound {
            success(poop)

            if player.won() {
                completed(player)
            }
        }

        gameDelegate?.nextTurn(for: player, flushed: poop.isFound)
    }

    init(player: Player, board: Board, index: Int) {
        self.player = player
        self.board = board
        self.index = index
    }
}

class AlternatingTurnStrategy: TurnStrategy, TurnStrategyProtocol {
    func playMove(success: (Poop) -> Void) {
        playMove(success: { poop in
            success(poop)
        }, failure: { player in
            gameDelegate?.nextPlayer(after: player)
        }, completed: { _ in
            gameDelegate?.gameOver()
        })
    }
}

class WholeBoardPerTurnStrategy: TurnStrategy, TurnStrategyProtocol {
    func playMove(success: (Poop) -> Void) {
        playMove(success: { poop in
            success(poop)
        }, failure: { player in
            gameDelegate?.nextTurn(for: player, flushed: false)
        }, completed: { player in
            if player.isHuman {
                gameDelegate?.nextPlayer(after: player)
            } else {
                gameDelegate?.gameOver()
            }
        })
    }
}
