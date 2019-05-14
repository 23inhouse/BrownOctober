//
//  FinalScoreViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 12/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class FinalScoreViewController: UIViewController {

    static let winText = "All poops where successfully evacuated!"
    static let looseText = "Unfortunately not all poops made it out alive"

    var winner: Player!
    var playerOneBoard: Board!
    var playerTwoBoard: Board!
    var playerOneBoardView: BoardUIView!
    var playerTwoBoardView: BoardUIView!
    var playerOneScoreView: ScoreUIView!
    var playerTwoScoreView: ScoreUIView!

    private func setupView() {
        let safeAreaView = SafeAreaUIView()
        view.addSubview(safeAreaView)
        safeAreaView.constrainTo(view.safeAreaLayoutGuide)

        let playersViews = UIStackView()
        playersViews.axis = .vertical
        playersViews.alignment = .fill
        playersViews.distribution = .equalSpacing
        safeAreaView.addSubview(playersViews)

        playersViews.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playersViews.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
            playersViews.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
            playersViews.topAnchor.constraint(equalTo: safeAreaView.topAnchor),
            playersViews.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor),
            ])

        addPlayerView(to: playersViews, for: playerOneBoard, with: playerOneBoardView, with: playerOneScoreView, position: 0)
        addButtonView(to: playersViews)
        addPlayerView(to: playersViews, for: playerTwoBoard, with: playerTwoBoardView, with: playerTwoScoreView, position: 1)
    }

    func addButtonView(to parentView: UIStackView) {
        let buttonsView = UIView()
        parentView.addArrangedSubview(buttonsView)

        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 40),
            ])

        let text = winner.isHuman ? type(of: self).winText : type(of: self).looseText
        let button = UIButton()
        button.setTitle("🚽 \(text) 🚽", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel!.font = button.titleLabel!.font.withSize(30)
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        buttonsView.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            button.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            button.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            ])
    }

    @objc private func touchButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PlayAgain", sender: self)
    }

    private func addPlayerView(to parentView: UIStackView, for board: Board, with boardView: BoardUIView, with scoreView: ScoreUIView, position: Int) {
        let playerView = UIView()
        parentView.addArrangedSubview(playerView)
        playerView.isUserInteractionEnabled = false
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            playerView.widthAnchor.constraint(equalTo: parentView.widthAnchor),
            ])

        let boardWrapperView = addBoardView(board, boardView, playerView: playerView, position: position)
        addScoreView(scoreView, playerView: playerView, boardWrapperView: boardWrapperView, position: position)
    }

    private func addBoardView(_ board: Board, _ boardView: BoardUIView, playerView: UIView, position: Int) -> UIView {
        let boardWrapperView = UIView()
        playerView.addSubview(boardWrapperView)
        boardWrapperView.translatesAutoresizingMaskIntoConstraints = false
        if position == 0 {
            NSLayoutConstraint.activate([
                boardWrapperView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
                boardWrapperView.topAnchor.constraint(equalTo: playerView.topAnchor),
                ])
        } else {
            NSLayoutConstraint.activate([
                boardWrapperView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor),
                boardWrapperView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
                ])
        }

        NSLayoutConstraint.activate([
            boardWrapperView.widthAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 0.75),
            boardWrapperView.heightAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 0.75),
            ])

        let playerBoardView = boardView
        playerBoardView.showUnevacuatedPoops(board: board)
        boardWrapperView.addSubview(playerBoardView)
        playerBoardView.constrainTo(boardWrapperView)

        return boardWrapperView
    }

    private func addScoreView(_ scoreView: ScoreUIView, playerView: UIView, boardWrapperView: UIView, position: Int) {
        let scoreWrapperView = UIView()
        playerView.addSubview(scoreWrapperView)
        scoreWrapperView.translatesAutoresizingMaskIntoConstraints = false
        if position == 0 {
            NSLayoutConstraint.activate([
                scoreWrapperView.leadingAnchor.constraint(equalTo: boardWrapperView.trailingAnchor, constant: 10),
                scoreWrapperView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -5),
                scoreWrapperView.topAnchor.constraint(equalTo: boardWrapperView.topAnchor),
                ])
        } else {
            NSLayoutConstraint.activate([
                scoreWrapperView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 5),
                scoreWrapperView.trailingAnchor.constraint(equalTo: boardWrapperView.leadingAnchor, constant: -10),
                scoreWrapperView.topAnchor.constraint(equalTo: boardWrapperView.topAnchor),
                ])
        }
        NSLayoutConstraint.activate([
            scoreWrapperView.heightAnchor.constraint(equalTo: playerView.heightAnchor, multiplier: 0.5),
            ])

        let playerScoreView = scoreView
        scoreWrapperView.addSubview(playerScoreView)
        playerScoreView.constrainTo(scoreWrapperView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}
