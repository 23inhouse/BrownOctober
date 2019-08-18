//
//  GridUIButton+valuable.swift
//  Brown October
//
//  Created by Benjamin Lewis on 19/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

extension GridUIButton: ValuableButton {
    internal func getText() -> String {
        return text!
    }

    func setData(text: String, color: UIColor, alpha: CGFloat) {
        self.text = text
        self.backgroundColor = color
        self.alpha = alpha
    }
}
