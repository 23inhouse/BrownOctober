//
//  ScoreUIView.swift
//  Brown October
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

class ScoreUIView: UIView {

    var newGameButtonDelegate: NewGameButtonDelegate?
    var solveGameButtonDelegate: SolveGameButtonDelegate?

    let icon: String
    let labelSpacing: CGFloat = 15

    let remainingFlushLabel = ScoreUILabel("🚽", score: 0)
    let foundPoopsLabel = ScoreUILabel("💩", score: 0)
    lazy var gamesWonLabel = ScoreUILabel(icon, score: 0)

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
        let view = UIStackView(arrangedSubviews: [gamesWonLabel, solveButton, newGameButton])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = labelSpacing

        return view
    }()

    func constrain(to otherView: UIView, min: CGFloat, max: CGFloat, height: CGFloat) {
        let constraintMinWidth = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .greaterThanOrEqual,
            toItem: otherView,
            attribute: .width,
            multiplier: min, constant: 0)

        let constraintMaxWidth = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .lessThanOrEqual,
            toItem: otherView,
            attribute: .width,
            multiplier: max, constant: 0)

        let constraintHeight = NSLayoutConstraint(
            item: labelsStackView,
            attribute: .height,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: height, constant: 0)

        translatesAutoresizingMaskIntoConstraints = false
        preservesSuperviewLayoutMargins = true
        NSLayoutConstraint.activate([
            constraintMinWidth,
            constraintMaxWidth,
            constraintHeight,
            ])
        labelsStackView.pin(labelsStackView.topAnchor, to: topAnchor)

        foundPoopsLabel.constrain(to: solveButton)
        remainingFlushLabel.constrain(to: newGameButton)
    }

    private func setupView() {
        addSubview(labelsStackView)
    }

    @objc private func solveGame(_ sender: UIButton) {
        sender.springy()
        solveGameButtonDelegate?.didTouchSolveGame()
    }

    @objc private func newGame(_ sender: UIButton) {
        sender.springy()
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
