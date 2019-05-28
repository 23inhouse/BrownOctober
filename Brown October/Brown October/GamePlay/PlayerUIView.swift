//
//  PlayerUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 8/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class PlayerUIView: UIView {

    let player: Player!

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

    let foundPoopsView = PoopUIView()
    lazy var scoreView = ScoreUIView(icon: player.isHuman ? "👤" : "📱")

    let boardView = BoardUIView()

    lazy var  board = player.board

    func setGridButtonDeletage(_ delegate: GridButtonDelegate) {
        boardView.setGridButtonDeletage(delegate)
    }

    func resetBoard() {
        boardView.reset()
        foundPoopsView.reset()
    }

    private func setupView() {
        backgroundColor = .white

        addSubview(layoutView)
        layoutView.addArrangedSubview(emptySpaceView)

        layoutView.addArrangedSubview(infoLayoutView)
        infoLayoutView.addArrangedSubview(foundPoopsView)
        infoLayoutView.addArrangedSubview(scoreView)

        layoutView.addArrangedSubview(boardView)

        resetBoard()
    }

    private func setupConstraints() {
        layoutView.constrain(to: self.safeAreaLayoutGuide)
        foundPoopsView.constrainWidth(to: layoutView, max: 0.75)
        scoreView.constrainWidth(to: layoutView, max: 0.25)
    }

    init(player: Player) {
        self.player = player
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
