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
    let isComputer: Bool
    lazy var board: Board = player.board

    lazy var playerView = { mainView }()
    lazy var boardView = { mainView.boardView }()
    lazy var poopView = { mainView.foundPoopsView }()
    lazy var scoreView = { mainView.scoreView }()

    lazy var foundPoops: Board = {
        var foundPoops = Board(width: PoopUIView.width, height: PoopUIView.height, poops: Poop.pinchSomeOff())
        let poops = foundPoops.poops

        _ = foundPoops.placePoop(poops[0], x: 5, y: 0, direction: 0, tiles: &foundPoops.tiles, check: false)
        _ = foundPoops.placePoop(poops[1], x: 4, y: 2, direction: 0, tiles: &foundPoops.tiles, check: false)
        _ = foundPoops.placePoop(poops[2], x: 3, y: 0, direction: 2, tiles: &foundPoops.tiles, check: false)
        _ = foundPoops.placePoop(poops[3], x: 3, y: 4, direction: 0, tiles: &foundPoops.tiles, check: false)
        _ = foundPoops.placePoop(poops[4], x: 1, y: 6, direction: 0, tiles: &foundPoops.tiles, check: false)
        _ = foundPoops.placePoop(poops[5], x: 0, y: 1, direction: 1, tiles: &foundPoops.tiles, check: false)

        return foundPoops
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

    func resetBoard() {
        let boardView = playerView.boardView

        if isComputer {
            let poopStains = UserData.retrievePoopStains()
            player.board.poopStains = poopStains
            player.board.placePoopStains()
        } else {
            player.board.placePoopsRandomly()
        }
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

        scoreView.solveGameButtonDelegate = self

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

        let button = sender as! GridUIButton
        let index = button.index
        let board = player.board

        button.springy()

        if let (_, poop) = board.wipe(at: index) {

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
