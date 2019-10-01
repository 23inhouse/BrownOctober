//
//  TurnStrategyProtocol.swift
//  Brown October
//
//  Created by Benjamin Lewis on 27/9/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol TurnStrategyProtocol {
    var game: Game { get }
    var gameDelegate: PlayerTurnDelegate? { get set }

    func playMove(for play: Player, on board: Board, at index: Int, flush: (Poop) -> Void)
}
