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
        guard !tile.isFound && !tile.isFound else { return }

        let button = sender as! GridUIButton
        let index = button.index

        button.springy()

        if let poop = board.wipe(at: index) {
            if poop.isFound {
                boardView.flush(ident: poop.identifier)
                poopView.flush(ident: poop.identifier)
                foundPoopsBoard.flush(by: poop.identifier)
                poopView.draw()

                if board.flushedAllPoops() {
                    playerTurnDelegate?.gameOver(from: self)
                    return
                }
            }

            playerTurnDelegate?.nextTurn(after: player, flushed: poop.isFound)
            return
        }

        playerTurnDelegate?.nextPlayer(after: player)
    }
}
