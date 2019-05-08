//
//  MenuUIView.swift
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

class MenuUIView: UIView {

    var newGameButtonDelegate: NewGameButtonDelegate!
    var solveGameButtonDelegate: SolveGameButtonDelegate!

    let buttonSpacing: CGFloat = 15
    let buttonPadding: CGFloat = 10
    let fontSize: CGFloat = 100

    lazy var buttonView = UIStackView(arrangedSubviews: menuUIButtons())

    func constrainTo(boardView: UIView, poopView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        let constraintWidth = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .height,
            multiplier: 1, constant: 0)

        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalTo: boardView.trailingAnchor, constant: -10),
            bottomAnchor.constraint(equalTo: poopView.bottomAnchor),
            topAnchor.constraint(equalTo: poopView.topAnchor),
            constraintWidth,
            ])

        buttonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonView.topAnchor.constraint(equalTo: topAnchor),
            buttonView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }

    private func menuUIButtons() -> [UIButton] {
        let solveButton = addButton("Solve 💩")
        solveButton.addTarget(self, action: #selector(solveGame), for: .touchUpInside)
        let newGameButton = addButton("Flush 🚽")
        newGameButton.addTarget(self, action: #selector(newGame), for: .touchUpInside)

        return [solveButton, newGameButton]
    }

    @objc private func solveGame() {
        solveGameButtonDelegate.didTouchSolveGame()
    }

    @objc private func newGame() {
        newGameButtonDelegate.didTouchNewGame()
    }

    private func addButton(_ text: String) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.96688156, green: 0.96688156, blue: 0.96688156, alpha: 1), for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.7921568627, green: 0.537254902, blue: 0.3607843137, alpha: 1)
        button.titleEdgeInsets.left = buttonPadding
        button.titleEdgeInsets.right = buttonPadding
        button.layer.cornerRadius = 20
        button.backgroundColor = #colorLiteral(red: 0.9304199219, green: 0.6907401839, blue: 0.4853004085, alpha: 1)
        setLabelData(button.titleLabel!)

        return button
    }

    private func setLabelData(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
    }

    private func setupView() {
        buttonView.axis = .vertical
        buttonView.alignment = .fill
        buttonView.distribution = .fillEqually
        buttonView.spacing = buttonSpacing

        addSubview(buttonView)
    }

    init() {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
