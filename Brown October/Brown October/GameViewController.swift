//
//  GameViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 4/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var mainView: UIStackView { return self.view as! UIStackView }

    lazy var brownOctober = BrownOctober()
    lazy var playerOne = brownOctober.playerOne
    lazy var playerTwo = brownOctober.playerTwo

    lazy var playerOneController: PlayerViewController = {
        let controller = PlayerViewController(playerOne)
        controller.playerTurnDelegate = self
        controller.updateGamesWonLabel()
        var board = playerOne.board
        if UserData.retrievePoopStains(for: &board) {
            controller.resetBoard(board)
        }
        add(controller)
        return controller
    }()
    lazy var playerTwoController: PlayerViewController = {
        let controller = PlayerViewController(playerTwo)
        controller.playerTurnDelegate = self
        controller.updateGamesWonLabel()
        controller.scoreView.newGameButtonDelegate = self
        add(controller)
        return controller
    }()

    lazy var playerOneView = playerOneController.mainView
    lazy var playerTwoView = playerTwoController.mainView

    lazy var computer = playerOneController.computer

    private func resetGame() {
        var board = brownOctober.playerOne.board
        if UserData.retrievePoopStains(for: &board) {
            playerOneController.resetBoard(board)
        } else {
            playerOneController.resetBoard()
        }
        playerTwoController.resetBoard()

        computer = playerOneController.computer
    }

    private func setupView() {
        self.view = UIStackView()
        mainView.axis = .horizontal
        mainView.alignment = .fill
        mainView.distribution = .fillEqually
        mainView.spacing = 30

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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWinner" {
            if let finalScoreViewController = segue.destination as? GameOverViewController {
                finalScoreViewController.winner = playerTwo.won() ? playerTwo: playerOne
            }
        }
    }
}

extension GameViewController: PlayerTurnDelegate {
    func gameOver(from sender: PlayerViewController) {
        playerTwoView.boardView.isUserInteractionEnabled = false

        sender.incrementGamesWon()

        if traitCollection.horizontalSizeClass == .compact {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.performSegue(withIdentifier: "ShowWinner", sender: self)
            })
        } else {
            playerOneView.boardView.showUnevacuatedPoops(board: playerOne.board)
            playerTwoView.boardView.showUnevacuatedPoops(board: playerTwo.board)
        }
    }

    func nextTurn(from sender: PlayerViewController, switchPlayer: Bool) {
        let player = sender.player
        let playerView = sender.playerView

        if switchPlayer == player.isHuman {
            playerView.boardView.isUserInteractionEnabled = false
        }

        let delay = player.isHuman ? 0.05 : 0.5

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            if switchPlayer {
                self.showOther(playerView: playerView)
            }

            let delay = self.turnDelay(switchPlayer)

            if switchPlayer == player.isHuman {
                self.playComputerTurn(delay: delay)
            }
        })
    }

    private func showOther(playerView: PlayerUIView) {
        let otherPlayerView = playerView.player.isHuman ? self.playerOneController.playerView : self.playerTwoController.playerView
        otherPlayerView.boardView.isUserInteractionEnabled = true

        guard traitCollection.horizontalSizeClass == .compact else { return }

        otherPlayerView.isHidden = false
        playerView.isHidden = true
    }

    private func turnDelay(_ switchPlayer: Bool) -> Double {
        let normal: Double = 0.25
        let switching: Double = 1.5

        guard traitCollection.horizontalSizeClass == .compact else { return normal }
        guard switchPlayer else { return normal }

        return switching
    }

    private func playComputerTurn(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { self.computer.playNext() })
    }

}

extension GameViewController: NewGameButtonDelegate {
    func didTouchNewGame() {
        resetGame()
    }
}
