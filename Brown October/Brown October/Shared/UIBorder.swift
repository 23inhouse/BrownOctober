//
//  UIBorder.swift
//  Brown October
//
//  Created by Benjamin Lewis on 24/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class UIBorder: UIView {
    enum Side {
        case top, left, right, bottom
    }

    static var sides: [Side] = [.top, .left, .right, .bottom]

    private let parent: UIView
    private let color: UIColor
    private let weight: CGFloat
    var sides: [Side]

    lazy private var topBorder: NSLayoutConstraint = {
        return topAnchor.constraint(equalTo: parent.topAnchor, constant: weight)
    }()

    lazy private var leftBorder: NSLayoutConstraint = {
        return leftAnchor.constraint(equalTo: parent.leftAnchor, constant: weight)
    }()

    lazy private var rightBorder: NSLayoutConstraint = {
        return rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -weight)
    }()

    lazy private var bottomBorder: NSLayoutConstraint = {
        return bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -weight)
    }()

    func activate(_ sides: [Side]) {
        self.sides = sides

        topBorder.constant = sides.contains(.top) ? weight : 0
        leftBorder.constant = sides.contains(.left) ? weight : 0
        rightBorder.constant = sides.contains(.right) ? -weight : 0
        bottomBorder.constant = sides.contains(.bottom) ? -weight : 0
    }

    func setupConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([topBorder, leftBorder, rightBorder, bottomBorder])
        activate(sides)
    }

    func setupView() {
        backgroundColor = parent.backgroundColor
        parent.backgroundColor = color
    }

    init(around parent: UIView, color: UIColor, weight: CGFloat, sides: [Side]) {
        self.parent = parent
        self.color = color
        self.weight = weight
        self.sides = sides

        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
