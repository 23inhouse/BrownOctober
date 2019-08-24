//
//  GridUIButton+borderable.swift
//  Brown October
//
//  Created by Benjamin Lewis on 24/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

extension GridUIButton: BorderableButton {
    func activate(sides: [UIBorder.Side]) {
        border.activate(sides)
    }

    func sides() -> [UIBorder.Side] {
        return border.sides
    }
}
