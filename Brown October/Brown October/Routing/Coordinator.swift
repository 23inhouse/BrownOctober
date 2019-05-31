//
//  Coordinator.swift
//  Brown October
//
//  Created by Benjamin Lewis on 31/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol Coordinator {
    var appViewController: AppViewController { get set }

    func start()
}
