//
//  PlayerViewController+gridbutton.swift
//  Brown October
//
//  Created by Benjamin Lewis on 19/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension PlayerViewController: GridButtonDelegate {
    func didTouchGridButton(_ sender: ValuableButton) {
        let tile = board.tile(at: sender.index)
        guard !tile.isFound && !tile.isFlushed else { return }

        let button = sender as! GridUIButton
        let index = button.index

        button.springy()

        playerTurnDelegate?.playMove(player, on: board, at: index, success: { poop in flush(poop: poop) })
    }
}
