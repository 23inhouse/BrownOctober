//
//  GridUIView.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 4/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GridUIStackView: UIStackView {

    var buttons = [GridUIButton]()

    func constrainTo(_ parentView: UIView) {
        let margin: CGFloat = 1

        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: margin),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -margin),
            topAnchor.constraint(equalTo: parentView.topAnchor, constant: margin),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -margin)])
    }

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
        spacing = active ? 2 : 1

        // hack to adjust emoji size bigger for the board grid and smaller for the poop grid
        let labelMargin:CGFloat = active ? 2 : 0
        var index = 0
        for i in 0 ..< rows {
            let hStackView = UIStackView()
            hStackView.axis = .horizontal
            hStackView.alignment = .fill
            hStackView.distribution = .fillEqually
            hStackView.spacing = spacing

            for j in 0 ..< cols {
                let button = GridUIButton(index: index, margin: labelMargin)
                let text = (i + j) % 2 == 0 ? "💩" : "🌊"
                button.setData(text: text, color: .white, alpha: 1)
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
