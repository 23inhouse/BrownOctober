//
//  UIView+orientation.swift
//  Brown October
//
//  Created by Benjamin Lewis on 27/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

extension UIView {

    static let longAxis: NSLayoutConstraint.Axis = {
        return UIView.isLandscape ? .horizontal : .vertical
    }()

    static let isLandscape: Bool = {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }()

    static let isPortrait: Bool = {
        return UIApplication.shared.statusBarOrientation.isPortrait
    }()
}
