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

    lazy var board: Board = Board.makeGameBoard()
    lazy var poops: [Poop] = board.poops
    lazy var dragger = Dragger(board, boardView)

    private func setupView() {
        let boardDecorator = ArrangeBoardDecorator(for: board)
        self.view = BoardSetupUIView(boardDecorator: boardDecorator)

        mainView.addSubview(boardView)

        boardView.buttons.forEach { [weak self] (button) in
            button.gridButtonDelegate = self
            button.gridButtonDragDelegate = self
        }

        loadBoard()
        boardView.draw()
    }

    private func loadBoard() {
        board.set(poopStains: UserData.retrievePoopStains())
        board.arrangePoops()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}

extension BoardSetupViewController: GridButtonDelegate {
    func didTouchGridButton(_ sender: ValuableButton) {
        let index = sender.index

        guard sender.getText() != "" else {
            let poop = poops[0]
            if ArrangedPoop(poop, board, direction: Direction(.left))?.move(to: index) ?? false {
                boardView.draw()
            }

            return
        }

        guard let poop = board.poop(at: index) else { return }
        if ArrangedPoop(poop, board)?.rotate() ?? false {
            boardView.draw()
        }
    }
}

extension BoardSetupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension BoardSetupViewController: GridButtonDragDelegate {
    func didDragGridButton(_ recognizer: UIPanGestureRecognizer) {
        dragger.call(recognizer) { poop, index in
            for dragIndex in dragger.dragRecord.reversedIndexes() {
                guard let adjustment = board.gridUtility.calcXYAdjustment(from: index, to: dragIndex) else { continue }

                if ArrangedPoop(poop, board)?.move(by: adjustment) ?? false {
                    break
                }
            }
            boardView.draw()
        }
    }
}
