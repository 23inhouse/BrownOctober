//
//  PlayerViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 10/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    var mainView: PlayerUIView { return self.view as! PlayerUIView }

    let player: Player
    let isComputer: Bool
    lazy var board: Board = player.board

    lazy var playerView = { mainView }()
    lazy var boardView = { mainView.boardView }()
    lazy var poopView = { mainView.foundPoopsView }()
    lazy var scoreView = { mainView.scoreView }()

    lazy var foundPoops: Board = {
        var board = Board(width: PoopUIView.width, height: PoopUIView.height, poops: Poop.pinchSomeOff())
        let poops = board.poops

        _ = ArrangedPoop(poops[0], board, direction: Direction(0))?.place(at: (6, 1), check: false)
        _ = ArrangedPoop(poops[1], board, direction: Direction(0))?.place(at: (5, 2), check: false)
        _ = ArrangedPoop(poops[2], board, direction: Direction(3))?.place(at: (1, 4), check: false)
        _ = ArrangedPoop(poops[3], board, direction: Direction(0))?.place(at: (5, 5), check: false)
        _ = ArrangedPoop(poops[4], board, direction: Direction(0))?.place(at: (4, 6), check: false)
        _ = ArrangedPoop(poops[5], board, direction: Direction(0))?.place(at: (2, 1), check: false)

        return board
    }()

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

    var showHeatSeak = false

    func resetBoard() {
        let boardView = playerView.boardView

        if isComputer {
            player.board.set(poopStains: UserData.retrievePoopStains())
        }
        player.board.arrangePoops()
        boardView.isUserInteractionEnabled = !isComputer
        playerView.resetBoard()

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

        return ComputerPlayer(board: board, boardViewProtocol: boardView, guesser: guesser)
    }

    private func setupView() {
        let boardDecorator = isComputer ? TeaseBoardDecorator(for: board) : BoardDecorator(for: board)
        let poopDecorator = PoopBoardDecorator(for: foundPoops)
        self.view = PlayerUIView(player: player, boardDecorator: boardDecorator, poopDecorator: poopDecorator)

        mainView.boardView.buttons.forEach { [weak self] (button) in
            button.gridButtonDelegate = self
        }

        scoreView.solveGameDelegate = self

        resetBoard()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    init(_ player: Player) {
        self.player = player
        self.isComputer = player.isComputer

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayerViewController: GridButtonDelegate {
    func didTouchGridButton(_ sender: GridButtonProtocol) {
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

    func didDragGridButton(_ sender: GridButtonProtocol) {}
}

extension PlayerViewController: SolveGameDelegate {
    func didTouchSolveGame() {
        guard !player.won() else { return }

        showHeatSeak.toggle()

        if showHeatSeak {
            let computerPlayer = getComputerPlayer()
            _ = computerPlayer.poopSeeker.calcRandomBestIndex(at: nil)
            boardView.draw(with: HeatMapBoardDecorator(for: computerPlayer.board))
        } else {
            boardView.draw(with: HeatMapBoardDecorator(for: Board.makeGameBoard()))
        }
    }
}
