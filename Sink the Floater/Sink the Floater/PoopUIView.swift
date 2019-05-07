//
//  PoopUIView.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class PoopUIView: UIView {

    lazy var gridView = GridUIStackView(cols: 15, rows: 7)
    lazy var buttons = gridView.buttons

    func constrainTo(_ boardView: UIView) {
        let constraintWidth = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: boardView,
            attribute: .width,
            multiplier: 0.63, constant: 0)
        let constraintHeight = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 0.46, constant: 0)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: boardView.leadingAnchor, constant: 10),
            bottomAnchor.constraint(equalTo: boardView.topAnchor, constant: -20),
            constraintWidth,
            constraintHeight
            ])

        gridView.constrainTo(self)
    }

    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1)

        addSubview(gridView)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
