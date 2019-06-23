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

    lazy var boardSetupViewController: BoardSetupViewController = { [weak self] in
        let controller = BoardSetupViewController()
        add(controller)
        return controller
        }()
    lazy var boardView = boardSetupViewController.mainView.boardView
    lazy var board = boardSetupViewController.board

    @objc func touchResetButton(_ sender: UIButton) {
        sender.springy()
        board.arrangePoops(reset: true)
        UserData.storePoopStains(board.poopStains)
        boardView.draw()
    }

    @objc func touchPlayButton(_ sender: UIButton) {
        sender.springy()
        UserData.storePoopStains(board.poopStains)
        coordinator?.playGame()
    }

    private func setupView() {
        self.view = GameSetupUIView()

        mainView.boardSubControllerViewContainer.addSubview(boardView)
        boardView.constrain(to: mainView.boardSubControllerViewContainer)

        mainView.resetButton.addTarget(self, action: #selector(touchResetButton), for: .touchUpInside)
        mainView.playButton.addTarget(self, action: #selector(touchPlayButton), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        switch traitCollection.horizontalSizeClass {
        case .compact:
            mainView.layoutView.axis = .vertical
            mainView.layoutView.distribution = .equalSpacing
            mainView.buttonsLayoutView.axis = .horizontal
        case .regular:
            mainView.layoutView.axis = .horizontal
            mainView.layoutView.distribution = .equalSpacing
            mainView.buttonsLayoutView.axis = .vertical
        case .unspecified:
            fallthrough
        @unknown default:
            mainView.layoutView.axis = .vertical
            mainView.layoutView.distribution = .equalSpacing
            mainView.buttonsLayoutView.axis = .horizontal
        }
    }
}
