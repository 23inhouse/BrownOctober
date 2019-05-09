//
//  ScoreUIView.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class ScoreUIView: UIStackView {

    let labelSpacing: CGFloat = 5
    let scoreMargin: CGFloat = 10
    let scoreTopMargin: CGFloat = 30

    let remaningFlushLabel = ScoreUILabel("🚽", score: 99)
    let foundPoopsLabel = ScoreUILabel("💩", score: 0)

    lazy var labelView = UIStackView(arrangedSubviews: [remaningFlushLabel, foundPoopsLabel])

    func constrainTo(parentView: UIView, poopView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: scoreMargin),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -scoreMargin),
            topAnchor.constraint(equalTo: parentView.topAnchor, constant: scoreTopMargin),
            bottomAnchor.constraint(equalTo: poopView.topAnchor, constant: -scoreMargin)
            ])
    }

    private func setupView() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        spacing = labelSpacing

        addArrangedSubview(remaningFlushLabel)
        addArrangedSubview(foundPoopsLabel)
    }

    init() {
        super.init(frame: .zero)

        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
