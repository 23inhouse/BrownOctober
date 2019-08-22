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
        return contentLabel.text!
    }

    func setData(text: String, color: UIColor, alpha: CGFloat) {
        self.contentLabel.text = text
        self.contentLabel.backgroundColor = color
        self.contentLabel.alpha = alpha
    }
}
