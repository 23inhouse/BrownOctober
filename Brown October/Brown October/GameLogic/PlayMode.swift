//
//  PlayMode.swift
//  Brown October
//
//  Created by Benjamin Lewis on 3/9/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

enum PlayMode: Int {
    case alternating, wholeBoard

    func next() -> PlayMode {
        switch self {
        case .alternating:
            return .wholeBoard
        case .wholeBoard:
            return .alternating
        }
    }
}
