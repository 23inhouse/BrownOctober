//
//  GameOverViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 24/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    static let winText = "💩🏆🥈🌈"
    static let looseText = "🧻🧴🧽🚿🍎🥦📱🖕"

    lazy var humanPlayer: Player = Player.human
    lazy var computerPlayer: Player = Player.computer
    lazy var winner: Player = Player.human

    var mainView: GameOverUIView { return self.view as! GameOverUIView }

    @objc private func touchButton(_ sender: UIButton) {
        sender.springy()
        self.performSegue(withIdentifier: "PlayAgain", sender: self)
    }

    private func setupView() {
        let text = winner.isHuman ? type(of: self).winText : type(of: self).looseText
        self.view = GameOverUIView(text: text)

        mainView.button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)

        set(scoreView: mainView.computerScoreView, for: computerPlayer)
        set(scoreView: mainView.humanScoreView, for: humanPlayer)
        self.setButtons(for: self.mainView.computerBoardView, from: self.computerPlayer)
        self.setButtons(for: self.mainView.humanBoardView, from: self.humanPlayer)
    }

    private func set(scoreView: ScoreUIView, for player: Player) {
        let numberFound = player.board.numberOfFoundTiles()
        let numberFlushed = player.board.numberOfFlushedTiles()
        scoreView.gamesWonLabel.setScore(score: UserData.retrieveGamesWon(for: player))
        scoreView.foundPoopsLabel.setScore(score: numberFound)
        scoreView.remainingFlushLabel.setScore(score: numberFlushed - numberFound)
    }

    private func setButtons(for boardView: BoardUIView, from player: Player) {
        for (i, tile) in player.board.tiles.enumerated() {
            let text = tile.isFound ? "💩" : tile.isFlushed ? "🌊" : " "
            var color: UIColor = .white
            if tile.poopIdentifier > 0 && (tile.isFlushed || !tile.isFound) {
                color = boardView.getTileColor(for: tile.poopIdentifier)
            }
            boardView.buttons[i].setData(text: text, color: color, alpha: 1)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}
