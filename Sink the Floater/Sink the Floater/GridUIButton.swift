//
//  GridUIButton.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol GridButtonDelegate {
    func didTouchGridButton(_ sender: GridButtonProtocol)
}

protocol GridButtonProtocol {
    func touch(_ sender: GridButtonProtocol)
    func getText() -> String
}

class GridUIButton: UIButton, GridButtonProtocol {

    var gridButtonDelegate: GridButtonDelegate!

    let index: Int
    lazy var label = UILabel()

    func setData(text: String, color: UIColor, alpha: CGFloat) {
        self.label.text = text
        self.backgroundColor = color
        self.alpha = alpha
    }

    private func constainLabel(margin: CGFloat) {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -margin),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: margin),
            label.topAnchor.constraint(equalTo: topAnchor, constant: -margin),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: margin)
            ])

    }

    private func setupView() {
        backgroundColor = .white
        addTarget(self, action: #selector(touchButton), for: .touchUpInside)

        label.font = label.font.withSize(50)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .center

        addSubview(label)
    }

    @objc private func touchButton(_ sender: GridUIButton) {
        touch(sender as GridButtonProtocol)
    }

    internal func touch(_ sender: GridButtonProtocol) {
        guard sender.getText() == "" else { return }
        gridButtonDelegate.didTouchGridButton(sender)
    }

    internal func getText() -> String {
        return label.text!
    }

    init(index: Int, margin: CGFloat) {
        self.index = index

        super.init(frame: .zero)

        setupView()
        constainLabel(margin: margin)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}