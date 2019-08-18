//
//  BoardViewProtocol.swift
//  Brown October
//
//  Created by Benjamin Lewis on 26/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol SetupableBoard: AnyObject {
    func getButton(at index: Int) -> SetupableButton
}

protocol PlayableBoard: AnyObject {
    func getButton(at index: Int) -> PlayableButton
}

protocol TouchableBoard: AnyObject {
    func getButton(at index: Int) -> TouchableButton
}

protocol ValuableBoard: AnyObject {
    func getButton(at index: Int) -> ValuableButton
}
