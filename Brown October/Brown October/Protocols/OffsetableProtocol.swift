//
//  OffsetableProtocol.swift
//  Brown October
//
//  Created by Benjamin Lewis on 26/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol OffsetableProtocol {
    var direction: Direction { get }
    var offset: (x: Int, y: Int) { get }
    var centerOffset: Int { get }

    func xOffset() -> Int
    func yOffset() -> Int
}
