//
//  PlayRule.swift
//  Brown October
//
//  Created by Benjamin Lewis on 27/9/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

enum PlayRule: Int {
    case american, brownOctober, russian, tetrazoid

    func next() -> PlayRule {
        switch self {
        case .american:
            return .brownOctober
        case .brownOctober:
            return .russian
        case .russian:
            return .tetrazoid
        case .tetrazoid:
            return .american
        }
    }
}
