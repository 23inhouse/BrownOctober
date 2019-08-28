//
//  PlayerUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 8/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class PlayerUIView: UIView {

    let player: Player
    let boardDecorator: BoardDecoratorProtocol
    let poopDecorator: BoardDecoratorProtocol

    let layoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 20
        return view
    }()

    let emptySpaceView = UIView()

    let infoLayoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.spacing = 0
        return view
    }()

    let boardView: BoardUIView
    let foundPoopsView: PoopUIView
    lazy var scoreView = ScoreUIView(icon: player.isHuman ? "👤" : "📱")

    lazy var board = player.board

    func draw() {
        boardView.draw()
        foundPoopsView.draw()
    }

    func set(boardDecorator decorator: BoardDecoratorProtocol) {
        boardView.decorator = decorator
    }

    func set(poopDecorator decorator: BoardDecoratorProtocol) {
        foundPoopsView.decorator = decorator
    }

    private func setupView() {
        backgroundColor = .white

        addSubview(layoutView)
        layoutView.addArrangedSubview(emptySpaceView)

        layoutView.addArrangedSubview(infoLayoutView)
        infoLayoutView.addArrangedSubview(foundPoopsView)
        infoLayoutView.addArrangedSubview(scoreView)

        layoutView.addArrangedSubview(boardView)

        draw()
    }

    private func setupConstraints() {
        layoutView.constrain(to: self.safeAreaLayoutGuide)
        foundPoopsView.constrainWidth(to: layoutView, max: 0.7)
        scoreView.constrainWidth(to: layoutView, max: 0.3)
    }

    init<Decorator: BoardDecoratorProtocol>(player: Player, boardDecorator: Decorator, poopDecorator: Decorator) {
        self.player = player
        self.boardDecorator = boardDecorator
        self.poopDecorator = poopDecorator
        self.boardView = BoardUIView(with: boardDecorator)
        self.foundPoopsView = PoopUIView(with: poopDecorator)

        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
