//
//  GameSetupUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 25/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameSetupUIView: UIView {

    let layoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalSpacing
        return view
    }()

    let emptySpaceView = UIView()

    let buttonsLayoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()

    lazy var resetButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.setTitle("🚽\nNEW", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = button.titleLabel!.font.withSize(buttonFontSize)
        button.titleLabel!.numberOfLines = 2
        button.titleLabel!.textAlignment = .center
        return button
    }()

    lazy var playButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.setTitle("💩\nPLAY", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = button.titleLabel!.font.withSize(buttonFontSize)
        button.titleLabel!.numberOfLines = 2
        button.titleLabel!.textAlignment = .center
        return button
    }()

    let boardSubControllerViewContainer = SquareUIView()

    let buttonFontSize: CGFloat = {
        return UIScreen.main.bounds.width / 9
    }()

    private func setupView() {
        backgroundColor = .white

        addSubview(layoutView)
        layoutView.addArrangedSubview(emptySpaceView)

        layoutView.addArrangedSubview(buttonsLayoutView)
        buttonsLayoutView.addArrangedSubview(resetButton)
        buttonsLayoutView.addArrangedSubview(playButton)
        layoutView.addArrangedSubview(boardSubControllerViewContainer)
    }

    private func setupConstraints() {
        layoutView.constrain(to: self.safeAreaLayoutGuide)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
