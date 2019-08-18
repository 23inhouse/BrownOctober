//
//  Dragger.swift
//  Brown October
//
//  Created by Benjamin Lewis on 18/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

struct Dragger {
    let board: Board
    let view: BoardUIView

    lazy var dragRecord = DragRecord(view: view)
    var dragButtons = [DraggableButton]()

    mutating func call(_ recognizer: UIPanGestureRecognizer, completionHandler: (Poop, Int) -> ()) {
        let button = recognizer.view as! ValuableButton
        let index = button.index

        guard let poop = board.poop(at: index) else { return }

        switch recognizer.state {
        case .began: began(poop: poop)
        case .changed: changed(recognizer: recognizer) { completionHandler(poop, index) }
        case .ended: finalize() { completionHandler(poop, index) }
        default: assertionFailure("Unhandled drag state")
        }
    }

    mutating private func began(poop: Poop) {
        let indexes = board.tileIndexes(for: poop.identifier)
        prepare(for: indexes)
    }

    mutating private func prepare(for indexes: [Int]) {
        dragButtons = indexes.map(duplicateButtonForDrag)
        dragRecord = DragRecord(view: view)
    }

    private func duplicateButtonForDrag(_ index: Int) -> DraggableButton {
        let button = (view as SetupableBoard).getButton(at: index)
        let dragButton = button.duplicate(in: view)
        button.setData(text: "", color: .white, alpha: 1)

        return dragButton
    }

    mutating private func changed(recognizer: UIPanGestureRecognizer, _ onCompletion: () -> ()) {
        let translation = recognizer.translation(in: view)
        dragRecord.storeIndex(at: recognizer)
        drag(translation: translation) { onCompletion() }
        recognizer.setTranslation(CGPoint.zero, in: view)
    }

    mutating private func drag(translation: CGPoint, onCompletion: () -> ()) {
        for dragButton in dragButtons {
            guard dragButton.contained(by: view) else {
                finalize(onCompletion)
                return
            }
        }

        for (i, dragButton) in dragButtons.enumerated() {
            dragButtons[i] = dragButton.translate(by: translation)
        }
    }

    private func finalize(_ onCompletion: () -> ()) {
        onCompletion()
        dragButtons.forEach { dragButton in dragButton.removeFromSuperview() }
    }

    init(_ board: Board, _ view: BoardUIView) {
        self.board = board
        self.view = view
    }
}
