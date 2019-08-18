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
    func didTouchGridButton(_ sender: ValuableButton) {
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
            dragger.dragRecord.storeIndex(at: recognizer)
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

struct Dragger {
    let view: BoardUIView

    lazy var dragRecord = DragRecord(view: view)
    var dragButtons = [DraggableButton]()

    mutating func prepare(for indexes: [Int]) {
        dragButtons = indexes.map(duplicateButtonForDrag)
        dragRecord = DragRecord(view: view)
    }

    mutating func drag(translation: CGPoint, onCompletion: () -> ()) {
        for dragButton in dragButtons {
            guard checkBounds(dragButton) else {
                finalize(onCompletion)
                return
            }
        }

        for (i, dragButton) in dragButtons.enumerated() {
            dragButtons[i].center = CGPoint(x: dragButton.center.x + translation.x, y: dragButton.center.y + translation.y)
        }
    }

    func finalize(_ onCompletion: () -> ()) {
        onCompletion()
        dragButtons.forEach { dragButton in dragButton.removeFromSuperview() }
    }

    private func duplicateButtonForDrag(_ index: Int) -> DraggableButton {
        let button = (view as SetupableBoard).getButton(at: index) as DraggableButton
        var dragButton = button.makeCopy()
        dragButton.center = button.superview!.convert(dragButton.center, to: view)
        dragButton.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)

        view.addSubview(dragButton as! UIView)
        (button as! ValuableButton).setData(text: "", color: .white, alpha: 1)

        return dragButton
    }

    private func checkBounds(_ dragButton: DraggableButton) -> Bool {
        guard let dragSuperView = dragButton.superview else { return false }
        let frame = dragSuperView.convert(dragButton.frame, to: view)
        let boardFrame = view.superview!.convert(view.frame, to: view)
        guard boardFrame.contains(frame) else { return false }

        return true
    }

    init(_ view: BoardUIView) {
        self.view = view
    }
}

struct DragRecord {
    let view: BoardUIView

    var indexes = [Int]()

    func Indexes() -> [Int] {
        return indexes.reversed()
    }

    mutating func storeIndex(at recognizer: UIPanGestureRecognizer) {
        let droppedAt = view.convert(recognizer.location(in: view), to: view)

        for tile in view.buttons {
            guard !indexes.contains(tile.index) else { continue }
            let frame = tile.superview!.convert(tile.frame, to: view)
            if frame.contains(droppedAt) {
                indexes.append(tile.index)
                break
            }
        }
    }

    init(view: BoardUIView) {
        self.view = view
    }
}
