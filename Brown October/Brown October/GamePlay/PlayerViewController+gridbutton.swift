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
        guard sender.getText() == "" else { return }

        defer {
            if showHeatSeak {
                let computerPlayer = getComputerPlayer()
                _ = computerPlayer.poopSeeker.calcRandomBestIndex(at: nil)
                boardView.draw(with: HeatMapBoardDecorator(for: computerPlayer.board))
            } else {
                boardView.draw(with: HeatMapBoardDecorator(for: Board.makeGameBoard()))
            }
        }

        let button = sender as! GridUIButton
        let index = button.index
        let board = player.board

        button.springy()

        if let poop = board.wipe(at: index) {

            button.setData(text: "💩", color: .white, alpha: 1)
            poopsFoundCount += 1

            if poop.isFound {
                boardView.flush(ident: poop.identifier)
                poopView.flush(ident: poop.identifier)

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

        board.tile(at: index).markAsFlushed()
        button.setData(text: "🌊", color: .white, alpha: 0.55)

        playerTurnDelegate?.nextTurn(from: self, switchPlayer: true)
    }

    func didDragGridButton(_ sender: ValuableButton) {}
}
