//
//  ScoreUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class ScoreUIView: UIView {

    weak var newGameDelegate: NewGameDelegate?
    weak var solveGameDelegate: SolveGameDelegate?

    let icon: String

    lazy var gamesWonLabel = ScoreUILabel(icon, score: 0)
    let remainingFlushLabel = ScoreUILabel("🚽", score: 0)
    let foundPoopsLabel = ScoreUILabel("💩", score: 0)

    lazy var solveButton: UIButton = {
        let button = UIButton()
        button.addSubview(foundPoopsLabel)
        button.addTarget(self, action: #selector(solveGame), for: .touchUpInside)
        return button
    }()
    lazy var newGameButton: UIButton = {
        let button = UIButton()
        button.addSubview(remainingFlushLabel)
        button.addTarget(self, action: #selector(newGame), for: .touchUpInside)
        return button
    }()

    lazy var labelsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()

    private func setupView() {
        addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(gamesWonLabel)
        labelsStackView.addArrangedSubview(solveButton)
        labelsStackView.addArrangedSubview(newGameButton)
    }

    private func setupConstraints() {
        let constraintMaxHeight = NSLayoutConstraint(
            item: labelsStackView,
            attribute: .height,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.5, constant: 0)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([constraintMaxHeight])

        labelsStackView.pin(labelsStackView.topAnchor, to: topAnchor)
        gamesWonLabel.constrainXAxis(to: self, margin: 10)
        solveButton.constrainXAxis(to: self, margin: 10)
        foundPoopsLabel.constrain(to: solveButton)
        newGameButton.constrainXAxis(to: self, margin: 10)
        remainingFlushLabel.constrain(to: newGameButton)
    }

    @objc private func solveGame(_ sender: UIButton) {
        sender.springy()
        solveGameDelegate?.didTouchSolveGame()
    }

    @objc private func newGame(_ sender: UIButton) {
        sender.springy()
        newGameDelegate?.didTouchNewGame()
    }

    init(icon: String) {
        self.icon = icon
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
