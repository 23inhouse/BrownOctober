//
//  GameViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 4/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    let mainView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 30
        return view
    }()

    let poopStains = UserData.retrievePoopStains()
    let playMode = UserData.retrievePlayMode()
    let difficultyLevel = UserData.retrieveDifficultyLevel()

    lazy var game = BrownOctober(difficultyLevel: difficultyLevel)

    var computerPlayer: Player { return game.computerPlayer }
    var player: Player { return game.player }

    lazy var playerController: PlayerViewController = { [weak self] in
        let controller = PlayerViewController(player)
        controller.playerTurnDelegate = self
        controller.newGameDelegate = self
        return controller
    }()

    lazy var playerView = playerController.mainView

    internal func resetGame() {
        game.arrangeBoards(playMode: playMode, poopStains: poopStains)
        player.foundPoopsBoard.arrangeFoundPoops()
        computerPlayer.foundPoopsBoard.arrangeFoundPoops()

        playerController.resetBoard()
    }

    internal func show(player: Player) {
        playerController.set(player: player)
        playerController.draw()
    }

    private func setupView() {
        resetGame()

        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.constrain(to: view.safeAreaLayoutGuide)
        mainView.addArrangedSubview(playerView)

        show(player: player)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}
