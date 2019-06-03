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
        view.spacing = 0
        return view
    }()

    let humanLayoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 0
        return view
    }()

    let computerBoardView: BoardUIView
    let humanBoardView: BoardUIView
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
        computerBoardView.constrainWidth(to: layoutView, max: 0.75)
        computerScoreView.constrainWidth(to: layoutView, max: 0.35)
        humanBoardView.constrainWidth(to: computerBoardView)
        humanScoreView.constrainWidth(to: computerScoreView)
    }

    init(text: String, humanboardDecorator: BoardDecoratorProtocol, computerboardDecorator: BoardDecoratorProtocol) {
        self.text = text
        self.humanBoardView = BoardUIView(with: humanboardDecorator)
        self.computerBoardView = BoardUIView(with: computerboardDecorator)

        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
