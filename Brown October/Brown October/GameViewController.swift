//
//  GameViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 4/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var playerOneController: PlayerViewController!
    var playerTwoController: PlayerViewController!

    var playersView: PlayersUIStackView!

    lazy var brownOctober = BrownOctober()
    lazy var playerOne = brownOctober.playerOne
    lazy var playerTwo = brownOctober.playerTwo

    lazy var computer = playerOneController.computer

    private func resetGame() {
        playerOneController.resetBoard()
        playerTwoController.resetBoard()

        computer = playerOneController.computer
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let safeAreaView = SafeAreaUIView()
        view.addSubview(safeAreaView)
        safeAreaView.constrainTo(view.safeAreaLayoutGuide)

        let playerOneController = buildPlayerViewController(brownOctober.playerOne)
        self.playerOneController = playerOneController

        let playerTwoController = buildPlayerViewController(brownOctober.playerTwo)
        playerTwoController.scoreView.newGameButtonDelegate = self
        self.playerTwoController = playerTwoController

        let playersView = PlayersUIStackView(playerOneView: playerOneController.playerView, playerTwoView: playerTwoController.playerView)
        safeAreaView.addSubview(playersView)
        playersView.constrainTo(safeAreaView)
        self.playersView = playersView
    }

    private func buildPlayerViewController(_ player: Player) -> PlayerViewController {
        let playerViewController = PlayerViewController(player)
        addChild(playerViewController)
        playerViewController.playerTurnDelegate = self
        playerViewController.viewDidLoad()

        return playerViewController
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        switch traitCollection.horizontalSizeClass {
        case .compact:
            playerOneController.playerView.isHidden = true
        case .regular:
            playerOneController.playerView.isHidden = false
        case .unspecified:
            fallthrough
        @unknown default:
            playerOneController.playerView.isHidden = false
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWinner" {
            if let finalScoreViewController = segue.destination as? FinalScoreViewController {
                finalScoreViewController.playerOneBoard = playerOneController.player.board
                finalScoreViewController.playerTwoBoard = playerTwoController.player.board
                finalScoreViewController.playerOneBoardView = playerOneController.boardView!
                finalScoreViewController.playerOneScoreView = playerOneController.scoreView!
                finalScoreViewController.playerTwoBoardView = playerTwoController.boardView!
                finalScoreViewController.playerTwoScoreView = playerTwoController.scoreView!
            }
        }
    }
}

extension GameViewController: PlayerTurnDelegate {
    func gameOver(from sender: PlayerViewController) {
        playerTwoController.boardView.isUserInteractionEnabled = false

        guard traitCollection.horizontalSizeClass == .compact else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.playersView.isHidden = true
            self.performSegue(withIdentifier: "ShowWinner", sender: self)
        })
    }

    func nextTurn(from sender: PlayerViewController, switchPlayer: Bool) {
        let player = sender.player
        let playerView = sender.playerView!

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
        let otherPlayerView = playerView.player.isHuman ? self.playerOneController.playerView! : self.playerTwoController.playerView!
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
