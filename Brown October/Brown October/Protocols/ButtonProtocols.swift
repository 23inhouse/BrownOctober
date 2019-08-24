//
//  ButtonProtocols.swift
//  Brown October
//
//  Created by Benjamin Lewis on 26/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

typealias DisplayableButton = BorderableButton & ValuableButton
typealias PlayableButton = TouchableButton & ValuableButton
typealias SetupableButton = DraggableButton & ValuableButton & BorderableButton

protocol BorderableButton {
    var border: UIBorder { get }

    func activate(sides: [UIBorder.Side])
    func sides() -> [UIBorder.Side]
}

protocol DraggableButton {
    func contained(by view: UIView) -> Bool
    func drag(recognizer: UIPanGestureRecognizer)
    func duplicate(in view: UIView) -> DraggableButton
    func removeFromSuperview()
    func translate(by translation: CGPoint) -> DraggableButton
}

protocol TouchableButton {
    func touch()
}

protocol ValuableButton {
    var index: Int { get }

    func getText() -> String
    func setData(text: String, color: UIColor, alpha: CGFloat)
}
