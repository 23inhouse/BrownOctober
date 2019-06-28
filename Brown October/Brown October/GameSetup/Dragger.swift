//
//  Dragger.swift
//  Brown October
//
//  Created by Benjamin Lewis on 26/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

struct Dragger {
    let view: BoardUIView

    var dragRecord: DragRecord
    var dragButtons = [GridUIButton]()

    mutating func prepare(for indexes: [Int]) {
        dragButtons = indexes.map(duplicateButtonForDrag)
        dragRecord = DragRecord(tiles: view.buttons as [DragableTile])
    }

    func drag(translation: CGPoint, onCompletion: () -> ()) {
        for dragButton in dragButtons {
            guard checkBounds(dragButton) else {
                finalize(onCompletion)
                return
            }
        }

        dragButtons.forEach { dragButton in
            dragButton.center = CGPoint(x: dragButton.center.x + translation.x, y: dragButton.center.y + translation.y)
        }
    }

    func finalize(_ onCompletion: () -> ()) {
        onCompletion()
        dragButtons.forEach { dragButton in dragButton.removeFromSuperview() }
    }

    private func duplicateButtonForDrag(_ index: Int) -> GridUIButton {
        let button = view.getButton(at: index) as! GridUIButton
        let dragButton = button.makeCopy()
        dragButton.center = button.superview!.convert(dragButton.center, to: view)
        dragButton.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)

        view.addSubview(dragButton)
        button.setData(text: "", color: .white, alpha: 1)

        return dragButton
    }

    private func checkBounds(_ dragButton: UIView) -> Bool {
        guard let dragSuperView = dragButton.superview else { return false }
        let frame = dragSuperView.convert(dragButton.frame, to: view)
        let boardFrame = view.superview!.convert(view.frame, to: view)
        guard boardFrame.contains(frame) else { return false }

        return true
    }

    init(_ view: BoardUIView) {
        self.view = view
        self.dragRecord = DragRecord(tiles: view.buttons as [DragableTile])
    }
}
