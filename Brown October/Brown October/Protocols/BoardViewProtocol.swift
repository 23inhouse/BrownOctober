//
//  BoardViewProtocol.swift
//  Brown October
//
//  Created by Benjamin Lewis on 26/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol BoardViewProtocol: class {
    func getButton(at index: Int) -> GridButtonProtocol
}
