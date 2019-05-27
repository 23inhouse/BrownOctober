//
//  GridUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 4/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GridUIStackView: UIStackView {

    let cols: Int
    let rows: Int
    let active: Bool

    var buttons = [GridUIButton]()

    func reset() {
        for button in buttons {
            button.setData(text: "", color: .white, alpha: 1)
        }
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = 0

        let buttonBorderWidth:CGFloat = active ? 1 : 0.5
        var index = 0
        for _ in 0 ..< rows {
            let hStackView = UIStackView()
            hStackView.axis = .horizontal
            hStackView.alignment = .fill
            hStackView.distribution = .fillEqually
            hStackView.spacing = spacing

            for _ in 0 ..< cols {
                let button = GridUIButton(index: index, borderWidth: buttonBorderWidth)
                button.setData(text: "", color: .white, alpha: 1)
                hStackView.addArrangedSubview(button)
                buttons.append(button)

                index += 1
            }

            self.addArrangedSubview(hStackView)
        }

    }

    init(cols: Int, rows: Int, active: Bool) {
        self.cols = cols
        self.rows = rows
        self.active = active

        super.init(frame: .zero)

        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
