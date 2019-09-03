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
        view.distribution = .fill
        return view
    }()

    let emptySpaceView = UIView()

    let buttonsWrapper: UIView = {
        let view = UIView()
        return view
    }()

    let buttonsLayoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()

    lazy var difficultyButton: GameSetupUIButton = {
        let button = GameSetupUIButton(text: "Difficulty", icon: "🧻")
        button.addTarget(self, action: #selector(touchDifficulty), for: .touchUpInside)
        return button
    }()
    lazy var modeButton: GameSetupUIButton = {
        let button = GameSetupUIButton(text: "Mode", icon: "🧻")
        button.addTarget(self, action: #selector(touchMode), for: .touchUpInside)
        return button
    }()
    lazy var playButton: GameSetupUIButton = {
        let button = GameSetupUIButton(text: "PLAY")
        button.addTarget(self, action: #selector(touchPlay), for: .touchUpInside)
        return button
    }()

    let boardSubControllerViewContainer = SquareUIView()

    @objc func touchDifficulty(_ sender: GameSetupUIButton) {
        sender.iconLabel.springy(scale: 0.8)
    }

    @objc func touchMode(_ sender: GameSetupUIButton) {
        sender.iconLabel.springy(scale: 0.8)
    }

    @objc func touchPlay(_ sender: GameSetupUIButton) {
        sender.springy()
    }

    private func setupView() {
        backgroundColor = .white

        addSubview(layoutView)

        layoutView.addArrangedSubview(buttonsWrapper)
        buttonsWrapper.addSubview(buttonsLayoutView)
        buttonsLayoutView.addArrangedSubview(difficultyButton)
        buttonsLayoutView.addArrangedSubview(modeButton)
        buttonsLayoutView.addArrangedSubview(playButton)
        layoutView.addArrangedSubview(boardSubControllerViewContainer)
    }

    private func setupConstraints() {
        layoutView.constrain(to: self.safeAreaLayoutGuide)
        buttonsLayoutView.constrain(to: buttonsWrapper, margin: (0, 40))
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
