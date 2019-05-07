//
//  BoardUIView.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol BoardProtocol {
    func getButton(at index: Int) -> GridButtonProtocol
}

class BoardUIView: UIView, BoardProtocol {

    lazy var gridView = GridUIStackView(cols: 10, rows: 10)
    lazy var buttons = gridView.buttons

    func constrainTo(_ layoutGuide: UILayoutGuide) {
        let constraintHeight = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1, constant: 0)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            constraintHeight
            ])

        gridView.constrainTo(self)
    }

    func getButton(at index: Int) -> GridButtonProtocol {
        return gridView.buttons[index]
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
