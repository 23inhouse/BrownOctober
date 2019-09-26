//
//  TurnStrategyProtocol.swift
//  Brown October
//
//  Created by Benjamin Lewis on 27/9/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol TurnStrategyProtocol {
    var player: Player { get }
    var board: Board { get }
    var index: Int { get }
    var gameDelegate: PlayerTurnDelegate? { get set }

    func playMove(success: (Poop) -> Void)
}
