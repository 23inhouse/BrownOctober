//
//  PlayersUIStackView.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 9/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class PlayersUIStackView: UIStackView {

    let spacer: CGFloat = 50

    let playerOneView: PlayerUIView!
    let playerTwoView: PlayerUIView!

    func constrainTo(_ parentView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            topAnchor.constraint(equalTo: parentView.topAnchor),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor)])
    }

    private func setupView() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        spacing = spacer

        addArrangedSubview(playerOneView)
        addArrangedSubview(playerTwoView)

        guard traitCollection.horizontalSizeClass == .compact else { return }

        playerOneView.constrainTo(self)
        playerTwoView.constrainTo(self)
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
