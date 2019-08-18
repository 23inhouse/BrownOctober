//
//  GridUIButton+touchable.swift
//  Brown October
//
//  Created by Benjamin Lewis on 19/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension GridUIButton: TouchableButton {
    internal func touch() {
        gridButtonDelegate?.didTouchGridButton(self)
    }
}
