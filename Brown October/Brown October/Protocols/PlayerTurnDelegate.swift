//
//  PlayerTurnDelegate.swift
//  Brown October
//
//  Created by Benjamin Lewis on 26/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol PlayerTurnDelegate: class {
    func nextTurn(from sender: PlayerViewController, switchPlayer: Bool)
    func gameOver(from sender: PlayerViewController)
}
