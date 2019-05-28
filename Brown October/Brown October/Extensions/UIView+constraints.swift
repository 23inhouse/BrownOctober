//
//  UIView+constraints.swift
//  Brown October
//
//  Created by Benjamin Lewis on 24/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

extension UIView {
    func constrain(to parentView: UIView, margin: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: margin),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -margin),
            topAnchor.constraint(equalTo: parentView.topAnchor, constant: margin),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -margin),
            ])
    }

    func constrain(to parentView: UIView, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            heightAnchor.constraint(equalToConstant: height),
            ])
    }

    func constrain(to layoutGuide: UILayoutGuide) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            ])
    }

    func constrainXAxis(to parentView: UIView, margin: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: margin),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -margin),
            ])
    }

    func constrainYAxis(to parentView: UIView, margin: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentView.topAnchor, constant: margin),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -margin),
            ])
    }

    func constrainHeight(to otherView: UIView, max: CGFloat = 1) {
        let constraintHeight = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: max == 1 ? .equal : .lessThanOrEqual,
            toItem: otherView,
            attribute: .height,
            multiplier: max, constant: 0)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            constraintHeight,
            ])
    }

    func constrainWidth(to otherView: UIView, max: CGFloat = 1) {
        let constraintWidth = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: max == 1 ? .equal : .lessThanOrEqual,
            toItem: otherView,
            attribute: .width,
            multiplier: max, constant: 0)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            constraintWidth,
            ])
    }

    func pin(_ anchor: NSLayoutXAxisAnchor, to otherAnchor: NSLayoutXAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([anchor.constraint(equalTo: otherAnchor)])
    }

    func pin(_ anchor: NSLayoutYAxisAnchor, to otherAnchor: NSLayoutYAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([anchor.constraint(equalTo: otherAnchor)])
    }
}
