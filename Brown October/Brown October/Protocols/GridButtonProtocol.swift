//
//  ValuableButton.swift
//  Brown October
//
//  Created by Benjamin Lewis on 26/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

typealias PlayableButton = TouchableButton & ValuableButton
typealias SetupableButton = DraggableButton & TouchableButton

protocol DraggableButton {
    var center: CGPoint { get set }
    var frame: CGRect { get }
    var layer: CALayer { get }
    var superview: UIView? { get }

    func drag(recognizer: UIPanGestureRecognizer)
    func makeCopy() -> DraggableButton
    func removeFromSuperview()
}

protocol TouchableButton {
    func touch()
}

protocol ValuableButton {
    func getText() -> String
    func setData(text: String, color: UIColor, alpha: CGFloat)
}
