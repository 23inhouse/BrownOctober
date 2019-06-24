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
    lazy var dragButtons = [GridUIButton]()

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
            board.setPoopStain(poop, x: 5, y: 5, direction: Direction(.left))
            if ArrangedPoop(poop, board)?.move(to: index) ?? false {
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
        let poopIdentifier = board.tile(at: button.index).poopIdentifier

        guard poopIdentifier > 0 else { return }

        switch recognizer.state {
        case .began:
            let indexes = board.tileIndexes(for: poopIdentifier)

            dragButtons = boardView.buttons.filter({ indexes.contains($0.index) }).map(duplicateForDrag)
            dragButtons.forEach { view.addSubview($0) }
        case .changed:
            for dragButton in dragButtons {
                guard checkBounds(dragButton, recognizer) else {
                    if move(poopIdentifier, by: recognizer) {
                        UserData.storePoopStains(board.poopStains)
                        boardView.draw()
                    }
                    dragButtons.forEach { $0.removeFromSuperview() }
                    break
                }
            }

            let translation = recognizer.translation(in: view)
            dragButtons.forEach { translate($0, by: translation) }
            recognizer.setTranslation(CGPoint.zero, in: view)
        case .ended:
            if move(poopIdentifier, by: recognizer) {
                UserData.storePoopStains(board.poopStains)
            }
            boardView.draw()
            dragButtons.forEach { $0.removeFromSuperview() }
        default:
            print("Error: WTF at drag recognizer state")
        }
    }

    private func duplicateForDrag(_ button: GridUIButton) -> GridUIButton {
        let duplicate = button.makeCopy()
        duplicate.center = button.superview!.convert(duplicate.center, to: view)
        duplicate.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)

        button.setData(text: "", color: .white, alpha: 1)

        return duplicate
    }

    private func checkBounds(_ dragButton: GridUIButton, _ recognizer: UIPanGestureRecognizer) -> Bool {
        guard let dragSuperView = dragButton.superview else { return false }
        let frame = dragSuperView.convert(dragButton.frame, to: view)
        let boardFrame = boardView.superview!.convert(boardView.frame, to: view)
        guard boardFrame.contains(frame) else { return false }

        return true
    }

    private func translate(_ button: GridUIButton, by translation: CGPoint) {
        button.center = CGPoint(x: button.center.x + translation.x, y: button.center.y + translation.y)
    }

    private func move(_ poopIdentifier: Int, by recognizer: UIPanGestureRecognizer) -> Bool {
        let poop = board.poops[poopIdentifier - 1]

        guard let adjustment = calcAdjustment(recognizer: recognizer) else { return false }
        guard ArrangedPoop(poop, board)?.move(by: adjustment) ?? false else { return false }

        return true
    }

    private func calcAdjustment(recognizer: UIPanGestureRecognizer) -> (Int, Int)? {
        let button = recognizer.view as! GridUIButton
        let droppedAt = view.convert(recognizer.location(in: view), to: boardView)

        for tile in boardView.buttons {
            let frame = tile.superview!.convert(tile.frame, to: boardView)
            if frame.contains(droppedAt) {
                return board.gridUtility.calcXYAdjustment(from: button.index, to: tile.index)
            }
        }
        return nil
    }
}
