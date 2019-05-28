//
//  GridUIButton.swift
//  Brown October
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol GridButtonDelegate {
    func didTouchGridButton(_ sender: GridButtonProtocol)
}

protocol GridButtonDragDelegate {
    func didDragGridButton(_ recognizer: UIPanGestureRecognizer)
}

protocol GridButtonProtocol {
    func touch()
    func drag(recognizer: UIPanGestureRecognizer)
    func getText() -> String
}

class GridUIButton: UILabel {

    var gridButtonDelegate: GridButtonDelegate?
    var gridButtonDragDelegate: GridButtonDragDelegate?

    let index: Int
    let borderWidth: CGFloat

    func setData(text: String, color: UIColor, alpha: CGFloat) {
        self.text = text
        self.backgroundColor = color
        self.alpha = alpha
    }

    private func setupView() {
        isUserInteractionEnabled = true
        backgroundColor = .white
        font = font.withSize(100)
        adjustsFontSizeToFitWidth = true
        numberOfLines = 1
        baselineAdjustment = .alignCenters
        textAlignment = .center
        layer.borderColor = #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1)
        layer.borderWidth = borderWidth

        let touch = UITapGestureRecognizer(target: self, action: #selector(touchButton))
        addGestureRecognizer(touch)

        let drag = UIPanGestureRecognizer(target: self, action: #selector(dragButton(recognizer:)))
        addGestureRecognizer(drag)
    }

    @objc private func touchButton() {
        touch()
    }

    @objc private func dragButton(recognizer: UIPanGestureRecognizer) {
        drag(recognizer: recognizer)
    }

    init(index: Int, borderWidth: CGFloat) {
        self.index = index
        self.borderWidth = borderWidth

        super.init(frame: .zero)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GridUIButton: GridButtonProtocol {
    internal func touch() {
        gridButtonDelegate?.didTouchGridButton(self)
    }

    internal func drag(recognizer: UIPanGestureRecognizer) {
        guard getText() != "" else { return }

        gridButtonDragDelegate?.didDragGridButton(recognizer)
    }

    internal func getText() -> String {
        return text!
    }
}
