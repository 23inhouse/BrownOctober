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
    let contentBackgroundColor: UIColor = .white
    let borderColor: UIColor = #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1)
    let borderWidth: CGFloat

    let contentLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = label.font.withSize(100)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.isUserInteractionEnabled = true

        return label
    }()

    lazy var border = UIBorder(around: self, color: borderColor, weight: borderWidth, sides: UIBorder.sides)

    private func setupView() {
        isUserInteractionEnabled = true
        backgroundColor = contentBackgroundColor

        addSubview(border)
        border.setupView()
        border.addSubview(contentLabel)

        let touch = UITapGestureRecognizer(target: self, action: #selector(touchButton))
        addGestureRecognizer(touch)

        let drag = UIPanGestureRecognizer(target: self, action: #selector(dragButton(recognizer:)))
        addGestureRecognizer(drag)
    }

    private func setupConstraints() {
        border.setupConstrains()
        contentLabel.constrain(to: border)
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
