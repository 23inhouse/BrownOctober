//
//  GameSetupViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 21/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameSetupViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    var mainView: GameSetupUIView { return self.view as! GameSetupUIView }

    lazy var boardSetupViewController = BoardSetupViewController()
    lazy var boardView = boardSetupViewController.mainView.boardView
    lazy var board = boardSetupViewController.board

    var difficultyLevel: Int = 1 {
        didSet {
            let papers = [String](repeating: "🧻", count: difficultyLevel)
            let poops = [String](repeating: "💩", count: 4 - difficultyLevel)
            difficultyButton.icon = (papers + poops).joined()
        }
    }

    var playMode: PlayMode = .alternating {
        didSet {
            switch playMode {
            case .alternating:
                modeButton.icon = "👤📱👤📱"
            case .wholeBoard:
                modeButton.icon = "👤👤📱📱"
            }
        }
    }

    lazy var difficultyButton = mainView.difficultyButton
    lazy var modeButton = mainView.modeButton
    lazy var playButton = mainView.playButton

    private func setupView() {
        self.view = GameSetupUIView()

        add(boardSetupViewController)

        mainView.boardSubControllerViewContainer.addSubview(boardView)
        boardView.constrain(to: mainView.boardSubControllerViewContainer)

        mainView.difficultyDelegate = self
        mainView.modeDelegate = self
        mainView.playDelegate = self

        difficultyLevel = UserData.retrieveDifficultyLevel()
        playMode = UserData.retrievePlayMode()

        guard playMode == .wholeBoard else { return }
        boardView.draw(with: WaveBoardDecorator(for: Board.makeGameBoard(), even: true))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}
