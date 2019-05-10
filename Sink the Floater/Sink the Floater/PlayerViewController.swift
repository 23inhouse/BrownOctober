//
//  PlayerViewController.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 10/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol PlayerTurnDelegate {
    func nextTurn(from sender: PlayerViewController, switchPlayer: Bool)
}

class PlayerViewController: UIViewController {

    let player: Player
    var playerView: PlayerUIView!
    var boardView: BoardUIView!
    var poopView: PoopUIView!
    var scoreView: ScoreUIView!

    lazy var computer = getComputerPlayer()

    var playerTurnDelegate: PlayerTurnDelegate!

    var remainingFlushCount = 99 {
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

        remainingFlushCount = 76
        poopsFoundCount = 0
    }

    private func getComputerPlayer() -> ComputerPlayer {
        let board = player.board
        let nextGuessClosure = ComputerPlayer.makeSingleDelayedGuessClosure

        return ComputerPlayer(board: board, boardProtocol: boardView, nextGuessClosure: nextGuessClosure)
    }

    private func flushPoop(_ ident: Int, board: Board, boardView: BoardUIView, poopView: PoopUIView) {
        let color = getColor(for: ident)

        for (i, tile) in board.tiles.enumerated() {
            if tile.poopIdentifier != ident { continue }

            tile.markAsFlushed()

            let button = boardView.buttons[i]
            button.setData(text: "💩", color: color, alpha: 1)
        }

        for (i, tile) in poopView.foundPoops.tiles.enumerated() {
            if tile.poopIdentifier != ident { continue }

            let button = poopView.buttons[i]
            button.setData(text: "💩", color: color, alpha: 1)
        }
    }

    private func getColor(for ident: Int) -> UIColor {
        let color: UIColor
        switch ident {
        case 1: color = #colorLiteral(red: 1, green: 0.8801414616, blue: 0.8755826288, alpha: 1)
        case 2: color = #colorLiteral(red: 0.9995340705, green: 0.9970265407, blue: 0.8813460202, alpha: 1)
        case 3: color = #colorLiteral(red: 0.950082893, green: 0.985483706, blue: 0.8672256613, alpha: 1)
        case 4: color = #colorLiteral(red: 0.88, green: 0.9984898767, blue: 1, alpha: 1)
        case 5: color = #colorLiteral(red: 0.88, green: 0.8864146703, blue: 1, alpha: 1)
        case 6: color = #colorLiteral(red: 1, green: 0.88, blue: 0.9600842213, alpha: 1)
        default: color = #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1)
        }

        return color
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

        if let (_, poop) = board.wipe(at: index) {
            button.setData(text: "💩", color: .white, alpha: 1)
            poopsFoundCount += 1

            if poop.isFound {
                flushPoop(poop.identifier, board: board, boardView: boardView, poopView: poopView)
            }

            if player.isComputer {
                playerTurnDelegate.nextTurn(from: self, switchPlayer: false)
            }
            return
        }

        remainingFlushCount -= 1

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
