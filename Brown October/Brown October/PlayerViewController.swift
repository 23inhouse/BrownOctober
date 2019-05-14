//
//  PlayerViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 10/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol PlayerTurnDelegate {
    func nextTurn(from sender: PlayerViewController, switchPlayer: Bool)
    func gameOver(from sender: PlayerViewController)
}

class PlayerViewController: UIViewController {

    let player: Player
    var playerView: PlayerUIView!
    var boardView: BoardUIView!
    var poopView: PoopUIView!
    var scoreView: ScoreUIView!

    lazy var computer = getComputerPlayer()

    var playerTurnDelegate: PlayerTurnDelegate!

    var remainingFlushCount = 0 {
        didSet {
            self.scoreView.remainingFlushLabel.setScore(score: remainingFlushCount)
        }
    }

    var poopsFoundCount = 0 {
        didSet {
            self.scoreView.foundPoopsLabel.setScore(score: poopsFoundCount)
        }
    }

    func resetBoard() {
        player.board.placePoopsRandomly()

        let boardView = playerView.boardView!
        boardView.isUserInteractionEnabled = true

        playerView.resetBoard()
        computer = getComputerPlayer()

        remainingFlushCount = 0
        poopsFoundCount = 0
    }

    private func getComputerPlayer() -> ComputerPlayer {
        let board = player.board
        let nextGuessClosure = ComputerPlayer.makeSingleDelayedGuessClosure

        return ComputerPlayer(board: board, boardProtocol: boardView, nextGuessClosure: nextGuessClosure)
    }

    private func flushPoop(_ ident: Int, board: Board, boardView: BoardUIView, poopView: PoopUIView) {
        let color = boardView.getTileColor(for: ident)

        for (i, tile) in board.tiles.enumerated() {
            if tile.poopIdentifier != ident { continue }

            tile.markAsFlushed()

            let button = boardView.buttons[i]
            button.setData(text: "💩", color: color, alpha: 1)
            button.springy()
        }

        for (i, tile) in poopView.foundPoops.tiles.enumerated() {
            if tile.poopIdentifier != ident { continue }

            let button = poopView.buttons[i]
            button.setData(text: "💩", color: color, alpha: 1)
            button.springy()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let playerView = PlayerUIView(player: player)
        view.addSubview(playerView)
        self.playerView = playerView
        self.boardView = playerView.boardView
        self.poopView = playerView.poopView
        self.scoreView = playerView.scoreView

        playerView.setGridButtonDeletage(self)
        scoreView.solveGameButtonDelegate = self

        resetBoard()
    }

    init(_ player: Player) {
        self.player  = player

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayerViewController: GridButtonDelegate {
    func didTouchGridButton(_ sender: GridButtonProtocol) {

        let button = sender as! GridUIButton
        let index = button.index
        let board = player.board

        button.springy()

        if let (_, poop) = board.wipe(at: index) {

            button.setData(text: "💩", color: .white, alpha: 1)
            poopsFoundCount += 1

            if poop.isFound {
                flushPoop(poop.identifier, board: board, boardView: boardView, poopView: poopView)

                if board.flushedAllPoops() {
                    playerTurnDelegate.gameOver(from: self)
                    return
                }
            }

            if player.isComputer {
                playerTurnDelegate.nextTurn(from: self, switchPlayer: false)
            }
            return
        }

        remainingFlushCount += 1

        board.tiles[index].markAsFlushed()
        button.setData(text: "🌊", color: .white, alpha: 0.65)

        playerTurnDelegate.nextTurn(from: self, switchPlayer: true)
    }
}

extension PlayerViewController: SolveGameButtonDelegate {
    func didTouchSolveGame() {
        computer.playNext()
    }
}
