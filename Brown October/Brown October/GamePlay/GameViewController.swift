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

    lazy var game = BrownOctober()
    var computerPlayer: Player { return game.computerPlayer }
    var player: Player { return game.player }
    let playMode = UserData.retrievePlayMode()

    lazy var playerController: PlayerViewController = { [weak self] in
        let controller = PlayerViewController(player)
        controller.playerTurnDelegate = self
        controller.newGameDelegate = self
        add(controller)
        return controller
    }()
    lazy var playerView = playerController.mainView

    internal func resetGame() {
        player.board.arrangePoops()
        player.foundPoopsBoard.arrangeFoundPoops()
        computerPlayer.board.set(poopStains: UserData.retrievePoopStains())
        computerPlayer.board.arrangePoops()
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
