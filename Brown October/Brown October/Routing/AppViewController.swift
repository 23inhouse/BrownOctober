//
//  AppViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 31/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {

    var appView = UIView()

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(appView)
        appView.constrain(to: view.safeAreaLayoutGuide)
        appView.backgroundColor = .red
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}
