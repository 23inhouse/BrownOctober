//
//  BoardSetupViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 23/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class BoardSetupViewController: UIViewController {

    var mainView: BoardSetupUIView { return self.view as! BoardSetupUIView }
    lazy var boardView = mainView.boardView

    var gameRule: PlayRule = .brownOctober
    lazy var board: Board = Board.makeGameBoard(for: gameRule)
    lazy var dragger = Dragger(board, boardView)

    func reset() {
        gameRule = UserData.retrieveGameRule()

        var poopStains = UserData.retrievePoopStains()
        if poopStains.count == 0 {
            let board = Board.makeFoundPoopsBoard(for: gameRule)
            UserData.storePoopStains(board.poopStains)
            poopStains = board.poopStains
        }

        board = Board.makeGameBoard(for: gameRule)
        board.set(poopStains: poopStains)
        board.arrangePoops()
        boardView.decorator = ArrangeBoardDecorator(for: board)
        boardView.draw()
        dragger = Dragger(board, boardView)
    }

    private func setupView() {
        let boardDecorator = ArrangeBoardDecorator(for: board)
        self.view = BoardSetupUIView(boardDecorator: boardDecorator)

        mainView.addSubview(boardView)

        boardView.buttons.forEach { [weak self] (button) in
            button.gridButtonDelegate = self
            button.gridButtonDragDelegate = self
        }

        reset()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}
