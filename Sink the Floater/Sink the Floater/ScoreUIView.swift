//
//  ScoreUIView.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class ScoreUIView: UIView {

    let labelSpacing: CGFloat = 5
    let labelPadding: CGFloat = 3
    let scorePadding: CGFloat = 10

    let remaningFlushLabel = ScoreUILabel("🚽", score: 99)
    let foundPoopsLabel = ScoreUILabel("💩", score: 0)
    lazy var labelView = UIStackView(arrangedSubviews: [remaningFlushLabel, foundPoopsLabel])

    func constrainTo(mainView: UIView, poopView: UIView, menuView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: poopView.leadingAnchor, constant: scorePadding),
            trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -scorePadding),
            topAnchor.constraint(equalTo: mainView.topAnchor, constant: 30),
            bottomAnchor.constraint(equalTo: poopView.topAnchor, constant: -10)
            ])

        labelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelView.topAnchor.constraint(equalTo: topAnchor),
            labelView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }

    private func setupView() {
        labelView.axis = .horizontal
        labelView.alignment = .fill
        labelView.distribution = .fillEqually
        labelView.spacing = labelSpacing

        addSubview(labelView)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
