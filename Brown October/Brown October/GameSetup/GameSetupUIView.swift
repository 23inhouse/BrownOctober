//
//  GameSetupUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 25/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameSetupUIView: UIView {
    weak var difficultyDelegate: DifficultyDelegate?
    weak var ruleDelegate: RuleSelectionDelegate?
    weak var modeDelegate: ModeSelectionDelegate?
    weak var playDelegate: PlayDelegate?

    let layoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()

    let buttonsWrapper: UIView = {
        let view = UIView()
        return view
    }()

    let buttonsLayoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalSpacing
        return view
    }()

    lazy var difficultyButton: GameSetupUIButton = {
        let button = GameSetupUIButton(text: "Difficulty", icon: "🧻")
        button.addTarget(self, action: #selector(touchDifficulty), for: .touchUpInside)
        return button
    }()
    lazy var ruleButton: GameSetupUIButton = {
        let button = GameSetupUIButton(text: "Rules", icon: "🧻")
        button.addTarget(self, action: #selector(touchRule), for: .touchUpInside)
        return button
    }()
    lazy var modeButton: GameSetupUIButton = {
        let button = GameSetupUIButton(text: "Mode", icon: "🧻")
        button.addTarget(self, action: #selector(touchMode), for: .touchUpInside)
        return button
    }()
    lazy var playButton: GameSetupUIButton = {
        let button = GameSetupUIButton(text: "", icon: "PLAY")
        button.addTarget(self, action: #selector(touchPlay), for: .touchUpInside)
        return button
    }()

    let boardSubControllerViewContainer = SquareUIView()

    @objc func touchDifficulty(_ sender: GameSetupUIButton) {
        sender.iconLabel.springy(scale: 0.8)
        difficultyDelegate?.didTouchToggleDifficulty()
    }

    @objc func touchMode(_ sender: GameSetupUIButton) {
        sender.iconLabel.springy(scale: 0.8)
        modeDelegate?.didTouchToggleMode()
    }

    @objc func touchRule(_ sender: GameSetupUIButton) {
        sender.iconLabel.springy(scale: 0.8)
        ruleDelegate?.didTouchToggleRule()
    }

    @objc func touchPlay(_ sender: GameSetupUIButton) {
        sender.springy()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playDelegate?.didTouchPlayGame()
        }
    }

    private func setupView() {
        backgroundColor = .white

        addSubview(layoutView)

        layoutView.addArrangedSubview(boardSubControllerViewContainer)
        layoutView.addArrangedSubview(buttonsWrapper)
        buttonsWrapper.addSubview(buttonsLayoutView)
        buttonsLayoutView.addArrangedSubview(playButton)
        buttonsLayoutView.addArrangedSubview(difficultyButton)
        buttonsLayoutView.addArrangedSubview(ruleButton)
        buttonsLayoutView.addArrangedSubview(modeButton)
    }

    private func setupConstraints() {
        layoutView.constrain(to: self.safeAreaLayoutGuide)
        buttonsLayoutView.constrain(to: buttonsWrapper, margin: (0, 20))
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
