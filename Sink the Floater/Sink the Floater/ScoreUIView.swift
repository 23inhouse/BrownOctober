//
//  ScoreUIView.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol NewGameButtonDelegate {
    func didTouchNewGame()
}

protocol SolveGameButtonDelegate {
    func didTouchSolveGame()
}

class ScoreUIView: UIStackView {

    var newGameButtonDelegate: NewGameButtonDelegate?
    var solveGameButtonDelegate: SolveGameButtonDelegate?

    let icon: String
    let labelSpacing: CGFloat = 5
    let scoreSpace: CGFloat = 40
    let scorePadding: CGFloat = 10

    let remainingFlushLabel = ScoreUILabel("🚽", score: 99)
    let foundPoopsLabel = ScoreUILabel("💩", score: 0)

    lazy var labelView = UIStackView(arrangedSubviews: [remainingFlushLabel, foundPoopsLabel])

    func constrainTo(parentView: UIView, poopView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: poopView.trailingAnchor, constant: scoreSpace),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -scorePadding),
            bottomAnchor.constraint(equalTo: poopView.bottomAnchor),
            topAnchor.constraint(equalTo: poopView.topAnchor),
            ])
    }

    private func setupView() {
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = labelSpacing

        let playerLabel = ScoreUILabel(icon, score: 0)
        let solveButton = buildButton(foundPoopsLabel, action: #selector(solveGame))
        let newGameButton = buildButton(remainingFlushLabel, action: #selector(newGame))

        addArrangedSubview(playerLabel)
        addArrangedSubview(solveButton)
        addArrangedSubview(newGameButton)
    }

    private func buildButton(_ label: ScoreUILabel, action: Selector) -> UIButton {
        let button = UIButton()
        button.addSubview(label)
        button.addTarget(self, action: action, for: .touchUpInside)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            label.topAnchor.constraint(equalTo: button.topAnchor),
            label.bottomAnchor.constraint(equalTo: button.bottomAnchor)
            ])


        return button
    }

    @objc private func solveGame() {
        solveGameButtonDelegate?.didTouchSolveGame()
    }

    @objc private func newGame() {
        newGameButtonDelegate?.didTouchNewGame()
    }

    init(icon: String) {
        self.icon = icon
        super.init(frame: .zero)

        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
