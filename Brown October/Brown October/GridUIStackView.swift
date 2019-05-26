//
//  GridUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 4/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GridUIStackView: UIStackView {

    var buttons = [GridUIButton]()

    private func setupView() {

    }

    func reset() {
        for button in buttons {
            button.setData(text: "", color: .white, alpha: 1)
        }
    }

    init(cols: Int, rows: Int, active: Bool) {
        super.init(frame: .zero)

        setupView()

        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = 0

        // hack to adjust emoji size bigger for the board grid and smaller for the poop grid
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

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
