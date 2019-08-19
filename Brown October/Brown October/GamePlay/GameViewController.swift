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
    lazy var playerOne = game.playerOne
    lazy var playerTwo = game.playerTwo

    lazy var playerOneController: PlayerViewController = { [weak self] in
        let controller = PlayerViewController(playerOne)
        controller.playerTurnDelegate = self
        controller.updateGamesWonLabel()
        add(controller)
        return controller
    }()
    lazy var playerTwoController: PlayerViewController = { [weak self] in
        let controller = PlayerViewController(playerTwo)
        controller.playerTurnDelegate = self
        controller.updateGamesWonLabel()
        controller.scoreView.newGameDelegate = self
        add(controller)
        return controller
    }()

    lazy var playerOneView = playerOneController.mainView
    lazy var playerTwoView = playerTwoController.mainView

    internal func resetGame() {
        playerOneController.resetBoard()
        playerTwoController.resetBoard()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.constrain(to: view.safeAreaLayoutGuide)

        playerOneView.isUserInteractionEnabled = false
        mainView.addArrangedSubview(playerOneView)
        mainView.addArrangedSubview(playerTwoView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        switch traitCollection.horizontalSizeClass {
        case .compact:
            playerOneView.isHidden = true
        case .regular:
            playerOneView.isHidden = false
        case .unspecified:
            fallthrough
        @unknown default:
            playerOneView.isHidden = false
        }
    }
}
