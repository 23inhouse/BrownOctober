//
//  GridButtonDragDelegate.swift
//  Brown October
//
//  Created by Benjamin Lewis on 26/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol GridButtonDragDelegate: AnyObject {
    func didDragGridButton(_ recognizer: UIPanGestureRecognizer)
}
