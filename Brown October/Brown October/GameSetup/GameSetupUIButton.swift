//
//  GameSetupUIButton.swift
//  Brown October
//
//  Created by Benjamin Lewis on 19/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameSetupUIButton: UIButton {
    let text: String
    var icon: String? {
        didSet { iconLabel.text = icon }
    }

    let layoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.isUserInteractionEnabled = false
        return view
    }()

    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = text
        label.font = label.font.withSize(textFontSize)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.text = icon
        label.font = label.font.withSize(textFontSize)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    let textFontSize: CGFloat = 34

    private func setupView() {
        backgroundColor = .white

        addSubview(layoutView)
        layoutView.addArrangedSubview(textLabel)
        if icon != nil {
            layoutView.addArrangedSubview(iconLabel)
        }
    }

    private func setupConstraints() {
        layoutView.constrain(to: self, margin: (0, 0))
    }

    init(text: String, icon: String? = nil) {
        self.text = text
        self.icon = icon
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
