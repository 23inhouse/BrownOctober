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
    lazy var dragger = Dragger(boardView)

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
    func didTouchGridButton(_ sender: GridButtonProtocol) {
        let button = sender as! GridUIButton
        let index = button.index

        guard sender.getText() != "" else {
            let poop = poops[0]
            if ArrangedPoop(poop, board, direction: Direction(.left))?.move(to: index) ?? false {
                boardView.draw()
            }

            return
        }

        let poopIdent = board.tile(at: index).poopIdentifier
        let poop = poops[poopIdent - 1]

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
        let button = recognizer.view as! GridUIButton
        let index = button.index
        let poopIdentifier = board.tile(at: index).poopIdentifier

        guard poopIdentifier > 0 else { return }

        let poop = board.poops[poopIdentifier - 1]

        switch recognizer.state {
        case .began:
            let indexes = board.tileIndexes(for: poopIdentifier)
            dragger.prepare(for: indexes)

        case .changed:
            let translation = recognizer.translation(in: boardView)
            let location = recognizer.location(in: boardView)
            let droppedAt = boardView.convert(location, to: boardView)
            dragger.dragRecord.storeIndex(at: droppedAt)
            dragger.drag(translation: translation) {
                onCompletion(for: poop, from: index)
            }
            recognizer.setTranslation(CGPoint.zero, in: boardView)

        case .ended:
            dragger.finalize() {
                onCompletion(for: poop, from: index)
            }

        default:
            assertionFailure("Unhandled drag state")
        }
    }

    private func onCompletion(for poop: Poop, from index: Int) {
        for dragIndex in dragger.dragRecord.Indexes() {
            guard let adjustment = board.gridUtility.calcXYAdjustment(from: index, to: dragIndex) else { continue }

            if ArrangedPoop(poop, board)?.move(by: adjustment) ?? false {
                break
            }
        }
        boardView.draw()
    }
}
