//
//  SquareUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 23/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class SquareUIView: UIView {


    private func setupConstraints() {
        let constraintWidth = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .height,
            multiplier: 1, constant: 0)

        let constraintHeight = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1, constant: 0)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            constraintWidth,
            constraintHeight,
            ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
