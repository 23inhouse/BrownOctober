//
//  SafeAreaUIView.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 9/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class SafeAreaUIView: UIView {
    func constrainTo(_ layoutGuide: UILayoutGuide) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
            ])
    }

    init() {
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
