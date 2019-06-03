//
//  GameOverViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 24/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    static let winText = "💩🏆🥈🌈"
    static let looseText = "🧻🧴🧽🚿🍎🥦📱🖕"

    lazy var humanBoard: Board = Board.buildGameBoard()
    lazy var computerBoard: Board = Board.buildGameBoard()
    lazy var winner: Player.key = Player.key.human

    var mainView: GameOverUIView { return self.view as! GameOverUIView }

    @objc private func touchButton(_ sender: UIButton) {
        sender.springy()
        coordinator?.start()
    }

    private func setupView() {
        let text = winner == Player.key.human ? type(of: self).winText : type(of: self).looseText
        let humanboardDecorator = RevealBoardDecorator(for: humanBoard)
        let computerboardDecorator = RevealBoardDecorator(for: computerBoard)
        self.view = GameOverUIView(text: text, humanboardDecorator: humanboardDecorator, computerboardDecorator: computerboardDecorator)

        mainView.button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)

        set(scoreView: mainView.computerScoreView, for: computerBoard, player: Player.key.computer)
        set(scoreView: mainView.humanScoreView, for: humanBoard, player: Player.key.human)

        mainView.computerBoardView.draw()
        mainView.humanBoardView.draw()
    }

    private func set(scoreView: ScoreUIView, for board: Board, player: Player.key) {
        let numberFound = board.numberOfFoundTiles()
        let numberFlushed = board.numberOfFlushedTiles()
        scoreView.gamesWonLabel.setScore(score: UserData.retrieveGamesWon(for: player))
        scoreView.foundPoopsLabel.setScore(score: numberFound)
        scoreView.remainingFlushLabel.setScore(score: numberFlushed - numberFound)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}
