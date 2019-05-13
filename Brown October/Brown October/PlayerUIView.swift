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
    let board: Board

    var boardView: BoardUIView!
    var poopView: PoopUIView!
    var scoreView: ScoreUIView!

    func constrainTo(_ parentView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            topAnchor.constraint(equalTo: parentView.topAnchor),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
            ])
    }

    func setGridButtonDeletage(_ delegate: GridButtonDelegate) {
        boardView.setGridButtonDeletage(delegate)
    }

    func resetBoard() {
        boardView.reset()
        poopView.reset()
    }

    private func setupView() {
        if player.isComputer {
            isUserInteractionEnabled = false
        }

        let boardView = BoardUIView()
        addSubview(boardView)
        boardView.constrainTo(self)
        self.boardView = boardView

        let poopView = PoopUIView()
        addSubview(poopView)
        poopView.constrainTo(boardView)
        self.poopView = poopView

        let scoreView = ScoreUIView(icon: player.isHuman ? "👤" : "📱")
        addSubview(scoreView)
        scoreView.constrainTo(parentView: self, poopView: poopView)
        self.scoreView = scoreView

        resetBoard()
    }

    init(player: Player) {
        self.player = player
        self.board = player.board

        super.init(frame: .zero)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
