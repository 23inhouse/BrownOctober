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

    var playMode: PlayMode
    var player: Player {
        didSet {
            let playerDecorator = PlayBoardDecorator(for: board)
            let boardDecorator = isComputer ? computerDecorator : playerDecorator
            let poopDecorator = PoopBoardDecorator(for: foundPoopsBoard)
            playerView.set(boardDecorator: boardDecorator)
            playerView.set(poopDecorator: poopDecorator)
        }
    }
    var computerDecorator: BoardDecoratorProtocol {
        switch playMode {
        case .alternating:
            return TeaseBoardDecorator(for: board)
        case .wholeBoard:
            return WaveBoardDecorator(for: board, even: true)
        }
    }

    var isComputer: Bool { return player.isComputer }
    var board: Board { return player.board }
    var foundPoopsBoard: Board { return player.foundPoopsBoard }

    lazy var playerView = { mainView }()
    lazy var boardView = { mainView.boardView }()
    lazy var poopView = { mainView.foundPoopsView }()
    lazy var scoreView = { mainView.scoreView }()

    weak var playerTurnDelegate: PlayerTurnDelegate?
    weak var newGameDelegate: NewGameDelegate?

    var gamesWonCount = 0 {
        didSet {
            self.scoreView.gamesWonLabel.setScore(score: gamesWonCount)
        }
    }

    var remainingFlushCount = 99 {
        didSet {
            guard remainingFlushCount >= 0 else { return }
            self.scoreView.remainingFlushLabel.setScore(score: remainingFlushCount)
        }
    }

    var poopsFoundCount = 0 {
        didSet {
            self.scoreView.foundPoopsLabel.setScore(score: poopsFoundCount)
        }
    }

    var showHeatSeak = false

    var initialRemainingFlushCount: Int = {
        let difficultyLevel = UserData.retrieveDifficultyLevel()
        return BrownOctober.calcMaxGuesses(difficultyLevel: difficultyLevel)
    }()

    func set(player: Player) {
        self.player = player
    }

    func draw() {
        boardView.isUserInteractionEnabled = !isComputer
        boardView.draw()
        poopView.draw()
        drawHeatSeak()

        updateGamesWonLabel()
        poopsFoundCount = board.score
        remainingFlushCount = initialRemainingFlushCount - board.misses
    }

    func drawHeatSeak() {
        guard showHeatSeak else { return }
        let computerPlayer = getComputerPlayer()
        _ = computerPlayer.poopSeeker.calcRandomBestIndex(at: nil)
        let decorator = HeatMapBoardDecorator(for: computerPlayer.board)
        boardView.draw(with: decorator)
    }

    func incrementGamesWon(for player: Player) {
        let count = UserData.retrieveGamesWon(for: player.key)
        UserData.storeGamesWon(for: player.key, count: count + 1)
    }

    func getComputerPlayer() -> ComputerPlayer {
        let board = player.board
        let guesser = Guesser(nextGuessClosure: Guesser.callFromQueueNow)

        return ComputerPlayer(board: board, boardViewProtocol: boardView as TouchableBoard, guesser: guesser)
    }

    func resetBoard() {
        updateGamesWonLabel()
        remainingFlushCount = initialRemainingFlushCount
        poopsFoundCount = 0
    }

    private func setupView() {
        let boardDecorator = PlayBoardDecorator(for: board)
        let poopDecorator = PoopBoardDecorator(for: foundPoopsBoard)
        self.view = PlayerUIView(player: player, boardDecorator: boardDecorator, poopDecorator: poopDecorator)

        mainView.boardView.buttons.forEach { [weak self] (button) in
            button.gridButtonDelegate = self
        }

        scoreView.solveGameDelegate = self
        scoreView.newGameDelegate = newGameDelegate

        resetBoard()
    }

    private func updateGamesWonLabel() {
        gamesWonCount = UserData.retrieveGamesWon(for: player.key)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    init(_ player: Player, playMode: PlayMode = .alternating) {
        self.player = player
        self.playMode = playMode

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
