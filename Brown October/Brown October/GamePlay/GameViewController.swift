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

    lazy var playerController: PlayerViewController = { [weak self] in
        let controller = PlayerViewController(player)
        controller.playerTurnDelegate = self
        controller.scoreView.newGameDelegate = self
        add(controller)
        return controller
    }()
    lazy var playerView = playerController.mainView

    internal func resetGame() {
        player.board.arrangePoops()
        player.foundPoopsBoard = setFoundPoopsBoard()
        computerPlayer.board.set(poopStains: UserData.retrievePoopStains())
        computerPlayer.board.arrangePoops()
        computerPlayer.foundPoopsBoard = setFoundPoopsBoard()

        playerController.resetBoard()
    }

    private func setFoundPoopsBoard() -> Board {
        let board = Board(width: PoopUIView.width, height: PoopUIView.height, poops: Poop.pinchSomeOff())
        let poops = board.poops

        _ = ArrangedPoop(poops[0], board, direction: Direction(0))?.place(at: (6, 1), check: false)
        _ = ArrangedPoop(poops[1], board, direction: Direction(0))?.place(at: (5, 2), check: false)
        _ = ArrangedPoop(poops[2], board, direction: Direction(3))?.place(at: (1, 4), check: false)
        _ = ArrangedPoop(poops[3], board, direction: Direction(0))?.place(at: (5, 5), check: false)
        _ = ArrangedPoop(poops[4], board, direction: Direction(0))?.place(at: (4, 6), check: false)
        _ = ArrangedPoop(poops[5], board, direction: Direction(0))?.place(at: (2, 1), check: false)

        return board
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
