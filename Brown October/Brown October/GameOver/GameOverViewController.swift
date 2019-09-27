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

    let winText = "💩🏆🥈🌈"
    let looseText = "🧻🧴🧽🚿🍎🥦📱🖕"
    let tieText = "👔⧓🇹🇭🥋👤=📱"

    lazy var humanBoard: Board = Board.makeGameBoard()
    lazy var computerBoard: Board = Board.makeGameBoard()
    lazy var winner: Player.Key? = nil
    lazy var maxGuesses: Int = 99

    var mainView: GameOverUIView { return self.view as! GameOverUIView }

    @objc private func touchButton(_ sender: UIButton) {
        coordinator?.start()
    }

    private func winnerText() -> String {
        if winner == Player.Key.human {
            return winText
        }
        if winner == Player.Key.computer {
            return looseText
        }

        return tieText
    }

    private func setupView() {

        let humanboardDecorator = RevealBoardDecorator(for: humanBoard)
        let computerboardDecorator = RevealBoardDecorator(for: computerBoard)
        self.view = GameOverUIView(text: winnerText(), humanboardDecorator: humanboardDecorator, computerboardDecorator: computerboardDecorator)

        mainView.button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)

        set(scoreView: mainView.computerScoreView, for: computerBoard, player: Player.Key.computer)
        set(scoreView: mainView.humanScoreView, for: humanBoard, player: Player.Key.human)

        mainView.computerBoardView.draw()
        mainView.humanBoardView.draw()
    }

    private func set(scoreView: ScoreUIView, for board: Board, player: Player.Key) {
        let numberFound = board.score
        scoreView.gamesWonLabel.setScore(score: UserData.retrieveGamesWon(for: player))
        scoreView.foundPoopsLabel.setScore(score: numberFound)
        scoreView.remainingFlushLabel.setScore(score: board.game.maxAllowedMisses - board.misses)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}
