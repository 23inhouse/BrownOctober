//
//  PlayerTurnDelegate.swift
//  Brown October
//
//  Created by Benjamin Lewis on 26/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol PlayerTurnDelegate: AnyObject {
    func playMove(_ player: Player, on board: Board, at index: Int, success: (Poop) -> Void)
    func nextTurn(for player: Player, flushed: Bool)
    func nextPlayer(after player: Player)
    func gameOver()
}
