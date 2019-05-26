//
//  PlayersUIStackView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 9/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class PlayersUIStackView: UIStackView {

    let spacer: CGFloat = 50

    let playerOneView: PlayerUIView!
    let playerTwoView: PlayerUIView!

    private func setupView() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        spacing = spacer

        addArrangedSubview(playerOneView)
        addArrangedSubview(playerTwoView)

        guard traitCollection.horizontalSizeClass == .compact else { return }

        playerOneView.constrain(to: self)
        playerTwoView.constrain(to: self)
    }


    init(playerOneView: PlayerUIView, playerTwoView: PlayerUIView) {
        self.playerOneView = playerOneView
        self.playerTwoView = playerTwoView

        super.init(frame: .zero)

        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
