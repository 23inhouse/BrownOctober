//
//  GridUIButton+draggable.swift
//  Brown October
//
//  Created by Benjamin Lewis on 19/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

extension GridUIButton: DraggableButton {
    func contained(by view: UIView) -> Bool {
        guard let superview = superview else { return false }
        guard let viewSuperview = view.superview else { return false }

        let buttonFrame = superview.convert(frame, to: view)
        let boardFrame = viewSuperview.convert(view.frame, to: view)
        return boardFrame.contains(buttonFrame)
    }

    internal func drag(recognizer: UIPanGestureRecognizer) {
        gridButtonDragDelegate?.didDragGridButton(recognizer)
    }

    func duplicate(in view: UIView) -> DraggableButton {
        let button = makeCopy()
        button.center = self.superview!.convert(button.center, to: view)
        button.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        view.addSubview(button)
        return button as DraggableButton
    }

    private func makeCopy() -> GridUIButton {
        let newButton = GridUIButton(index: index, borderWidth: borderWidth)
        newButton.setData(text: getText(), color: backgroundColor!, alpha: alpha)
        newButton.frame = frame

        return newButton
    }

    func translate(by translation: CGPoint) -> DraggableButton {
        center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
        return self as DraggableButton
    }
}
