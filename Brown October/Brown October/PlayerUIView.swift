//
//  PlayerUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 8/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class PlayerUIView: UIView {

    let layoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 20
        return view
    }()

    let emptySpaceView = UIView()

    let scoreLayoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 20
        return view
    }()

    let foundPoopsView = PoopUIView()
    lazy var scoreView = ScoreUIView(icon: player.isHuman ? "👤" : "📱")

    let boardView = BoardUIView()

    let player: Player
    let board: Board

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

        layoutView.addArrangedSubview(scoreLayoutView)
        scoreLayoutView.addArrangedSubview(foundPoopsView)
        scoreLayoutView.addArrangedSubview(scoreView)

        layoutView.addArrangedSubview(boardView)

        resetBoard()
    }

    private func setupConstraints() {
        layoutView.constrain(to: self.safeAreaLayoutGuide)
        foundPoopsView.constrain()
        scoreView.constrain(to: scoreLayoutView, min: 0.25, max: 0.3, height: 1.5)

        boardView.constrain()
    }

    init(player: Player) {
        self.player = player
        self.board = player.board

        super.init(frame: .zero)

        if player.isComputer {
            isUserInteractionEnabled = false
        }

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
