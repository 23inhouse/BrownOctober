//
//  PlayerTurnDelegate.swift
//  Brown October
//
//  Created by Benjamin Lewis on 26/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol PlayerTurnDelegate: AnyObject {
    var firstPlayer: Player { get }

    func playMove(for player: Player, on board: Board, at index: Int)
    func nextTurn(for player: Player, flushed: Bool)
    func nextPlayer(after player: Player)
    func gameOver(from player: Player)
}
