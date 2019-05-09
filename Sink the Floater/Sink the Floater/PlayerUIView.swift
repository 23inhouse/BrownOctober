//
//  PlayerUIView.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 8/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class PlayerUIView: UIView {

    var boardView: BoardUIView!
    var poopView: PoopUIView!
    var menuView: MenuUIView!
    var scoreView: ScoreUIView!

    func constrainTo(_ layoutGuide: UILayoutGuide) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
            ])
    }

    func setGridButtonDeletage(_ delegate: GridButtonDelegate) {
        boardView.setGridButtonDeletage(delegate)
    }

    private func setupView() {
        let boardView = BoardUIView()
        addSubview(boardView)
        boardView.constrainTo(self)
        self.boardView = boardView

        let poopView = PoopUIView()
        addSubview(poopView)
        poopView.constrainTo(boardView)
        self.poopView = poopView

        let menuView = MenuUIView()
        addSubview(menuView)
        menuView.constrainTo(boardView: boardView, poopView: poopView)
        self.menuView = menuView

        let scoreView = ScoreUIView()
        addSubview(scoreView)
        scoreView.constrainTo(parentView: self, poopView: poopView)
        self.scoreView = scoreView
    }

    init() {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
