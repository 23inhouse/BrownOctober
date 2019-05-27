//
//  GameOverUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 24/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameOverUIView: UIView {

    let text: String!

    let buttonFontSize:CGFloat = 50
    let buttonHeight:CGFloat = 90

    let layoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalCentering
        view.spacing = 1
        return view
    }()

    let computerLayoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 20
        return view
    }()

    let humanLayoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 20
        return view
    }()

    let computerBoardView = BoardUIView()
    let humanBoardView = BoardUIView()
    let computerScoreView = ScoreUIView(icon: "📱")
    let humanScoreView = ScoreUIView(icon: "👤")

    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(self.text, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel!.font = button.titleLabel!.font.withSize(self.buttonFontSize)
        button.titleLabel!.adjustsFontSizeToFitWidth = true

        return button
    }()

    private func setupView() {
        backgroundColor = .white

        addSubview(layoutView)

        layoutView.addArrangedSubview(computerLayoutView)
        computerLayoutView.addArrangedSubview(computerBoardView)
        computerLayoutView.addArrangedSubview(computerScoreView)

        layoutView.addArrangedSubview(button)

        layoutView.addArrangedSubview(humanLayoutView)
        humanLayoutView.addArrangedSubview(humanScoreView)
        humanLayoutView.addArrangedSubview(humanBoardView)
    }

    private func setupConstraints() {
        layoutView.constrain(to: self.safeAreaLayoutGuide)
        button.constrain(to: self, height: buttonHeight)
        computerBoardView.constrain()
        computerBoardView.constrain(to: layoutView, width: 0.75)
        computerScoreView.constrain(to: computerLayoutView, min: 0.15, max: 0.25, height: 1.5)
        NSLayoutConstraint.activate([
            computerScoreView.labelsStackView.rightAnchor.constraint(equalTo: computerScoreView.rightAnchor, constant: -10)
            ])
        humanBoardView.constrain()
        humanBoardView.constrainWidth(to: computerBoardView)
        humanScoreView.constrain(to: humanLayoutView, min: 0.15, max: 0.25, height: 1.5)
        NSLayoutConstraint.activate([
            humanScoreView.labelsStackView.leftAnchor.constraint(equalTo: humanScoreView.leftAnchor, constant: 10)
            ])
    }

    init(text: String) {
        self.text = text

        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
