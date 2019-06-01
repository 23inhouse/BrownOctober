//
//  AppCoordinator.swift
//  Brown October
//
//  Created by Benjamin Lewis on 31/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    var appViewController: AppViewController
    var previousViewController: UIViewController?

    init(appViewController: AppViewController) {
        self.appViewController = appViewController
    }

    func start() {
        let viewController = GameSetupViewController()
        viewController.coordinator = self
        go(to: viewController)
    }

    func playGame() {
        let viewController = GameViewController()
        viewController.coordinator = self
        go(to: viewController)
    }

    func gameOver(winner: Player.key, humanBoard: Board, computerBoard: Board) {
        let viewController = GameOverViewController()
        viewController.coordinator = self
        viewController.winner = winner
        viewController.humanBoard = humanBoard
        viewController.computerBoard = computerBoard
        go(to: viewController)
    }

    private func go(to viewController: UIViewController) {
        guard let view = viewController.view else { return }

        appViewController.add(viewController)
        appViewController.appView.addSubview(view)
        view.constrain(to: appViewController.appView)

        if let previousViewController = previousViewController {
            previousViewController.remove()
        }
        previousViewController = viewController
    }
}
