//
//  ScoreUILabel.swift
//  Brown October
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class ScoreUILabel: UILabel {

    let label: String
    var score: Int

    let fontSize: CGFloat = UIScreen.main.bounds.height / 20

    func setScore(score: Int) {
        self.score = score
        text = getText()
    }

    private func setupView() {
        text = getText()
        textColor = .black
        textAlignment = .left
        adjustsFontSizeToFitWidth = true
        font = font.withSize(fontSize)
    }

    private func getText() -> String {
        return "\(label) \(scoreString())"
    }

    private func scoreString() -> String {
        return String(describing: score).spaced(width: 2, with: "0")
    }

    init(_ label: String, score: Int) {
        self.label = label
        self.score = score

        super.init(frame: .zero)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
