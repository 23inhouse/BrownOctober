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

        defer {
            boardView.draw()
            poopView.draw()

            if showHeatSeak {
                let computerPlayer = getComputerPlayer()
                _ = computerPlayer.poopSeeker.calcRandomBestIndex(at: nil)
                boardView.draw(with: HeatMapBoardDecorator(for: computerPlayer.board))
            }
        }

        let button = sender as! GridUIButton
        let index = button.index

        button.springy()

        if let poop = board.wipe(at: index) {
            poopsFoundCount += 1

            if poop.isFound {
                boardView.flush(ident: poop.identifier)
                poopView.flush(ident: poop.identifier)
                foundPoops.flush(by: poop.identifier)

                if board.flushedAllPoops() {
                    playerTurnDelegate?.gameOver(from: self)
                    return
                }
            }

            if player.isComputer {
                playerTurnDelegate?.nextTurn(from: self, switchPlayer: false)
            }
            return
        }

        remainingFlushCount += 1

        playerTurnDelegate?.nextTurn(from: self, switchPlayer: true)
    }
}
