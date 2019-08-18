//
//  GridUIButton.swift
//  Brown October
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GridUIButton: UILabel {

    weak var gridButtonDelegate: GridButtonDelegate?
    weak var gridButtonDragDelegate: GridButtonDragDelegate?

    let index: Int
    let borderWidth: CGFloat

    let heatMapLabel: UILabel = {
        let label = UILabel()
        label.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()

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

        addSubview(heatMapLabel)

        let touch = UITapGestureRecognizer(target: self, action: #selector(touchButton))
        addGestureRecognizer(touch)

        let drag = UIPanGestureRecognizer(target: self, action: #selector(dragButton(recognizer:)))
        addGestureRecognizer(drag)
    }

    private func setupConstraints() {
        heatMapLabel.constrain(to: self)
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
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GridUIButton: DraggableButton {
    internal func drag(recognizer: UIPanGestureRecognizer) {
        gridButtonDragDelegate?.didDragGridButton(recognizer)
    }

    func duplicate(in view: UIView) -> DraggableButton {
        var button = makeCopy()
        button.center = self.superview!.convert(button.center, to: view)
        button.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        view.addSubview(button as! UIView)
        return button
    }

    private func makeCopy() -> DraggableButton {
        let newButton = GridUIButton(index: index, borderWidth: borderWidth)
        newButton.setData(text: getText(), color: backgroundColor!, alpha: alpha)
        newButton.frame = frame

        return newButton as DraggableButton
    }
}

extension GridUIButton: TouchableButton {
    internal func touch() {
        gridButtonDelegate?.didTouchGridButton(self)
    }
}

extension GridUIButton: ValuableButton {
    internal func getText() -> String {
        return text!
    }

    func setData(text: String, color: UIColor, alpha: CGFloat) {
        self.text = text
        self.backgroundColor = color
        self.alpha = alpha
    }
}
