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
