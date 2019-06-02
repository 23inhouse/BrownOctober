//
//  PlayerViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 10/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol PlayerTurnDelegate: class {
    func nextTurn(from sender: PlayerViewController, switchPlayer: Bool)
    func gameOver(from sender: PlayerViewController)
}

class PlayerViewController: UIViewController {

    var mainView: PlayerUIView { return self.view as! PlayerUIView }

    let player: Player
    lazy var playerView = { mainView }()
    lazy var boardView = { mainView.boardView }()
    lazy var poopView = { mainView.foundPoopsView }()
    lazy var scoreView = { mainView.scoreView }()

    weak var playerTurnDelegate: PlayerTurnDelegate?

    var gamesWonCount = 0 {
        didSet {
            self.scoreView.gamesWonLabel.setScore(score: gamesWonCount)
        }
    }

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

    func resetBoard(_ board: Board? = nil) {
        let boardView = playerView.boardView

        if let board = board {
            player.board.poopStains = board.poopStains
            player.board.placePoopStains()
            boardView.isUserInteractionEnabled = false
            playerView.resetBoard()

            boardView.showUnevacuatedPoops(board: board)
        } else {
            player.board.placePoopsRandomly()
            boardView.isUserInteractionEnabled = true
            playerView.resetBoard()
        }

        remainingFlushCount = 0
        poopsFoundCount = 0
    }

    func updateGamesWonLabel() {
        gamesWonCount = UserData.retrieveGamesWon(for: player.key)
    }

    func incrementGamesWon() {
        let count = UserData.retrieveGamesWon(for: player.key)
        gamesWonCount = count + 1
        UserData.storeGamesWon(for: player.key, count: gamesWonCount)
    }

    func getComputerPlayer() -> ComputerPlayer {
        let board = player.board
        let guesser = Guesser(nextGuessClosure: Guesser.callFromQueueNow)

        return ComputerPlayer(board: board, boardProtocol: boardView, guesser: guesser)
    }

    private func flushPoop(_ ident: Int, board: Board, boardView: BoardUIView, poopView: PoopUIView) {
        let color = UIColor(poop: ident)

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

    private func setupView() {
        self.view = PlayerUIView(player: player)

        mainView.boardView.buttons.forEach { [weak self] (button) in
            button.gridButtonDelegate = self
        }

        scoreView.solveGameButtonDelegate = self

        resetBoard()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    init(_ player: Player) {
        self.player = player

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayerViewController: GridButtonDelegate {
    func didTouchGridButton(_ sender: GridButtonProtocol) {
        guard sender.getText() == "" else { return }

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

        board.tiles[index].markAsFlushed()
        button.setData(text: "🌊", color: .white, alpha: 0.55)

        playerTurnDelegate?.nextTurn(from: self, switchPlayer: true)
    }

    func didDragGridButton(_ sender: GridButtonProtocol) {}
}

extension PlayerViewController: SolveGameButtonDelegate {
    func didTouchSolveGame() {
        guard !player.won() else { return }

        if !mainView.isHidden {
            getComputerPlayer().playNext()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.didTouchSolveGame()
        }
    }
}
