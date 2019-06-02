//
//  BoardUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol BoardProtocol: class {
    func getButton(at index: Int) -> GridButtonProtocol
}

class BoardUIView: UIView {

    lazy var gridView = GridUIStackView(cols: 10, rows: 10, active: true)
    lazy var buttons = gridView.buttons

    func reset() {
        gridView.reset()
    }

    func showUnevacuatedPoops(board: Board) {
        for (i, tile) in board.tiles.enumerated() {
            if tile.poopIdentifier > 0 && !tile.isFound {
                let button = getButton(at: i) as! GridUIButton
                button.backgroundColor = UIColor(poop: tile.poopIdentifier)
            }
        }
    }

    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1)

        addSubview(gridView)
    }

    private func setupConstraints() {
        let constraintWidth = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .height,
            multiplier: 1, constant: 0)

        let constraintHeight = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1, constant: 0)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            constraintWidth,
            constraintHeight,
            ])

        gridView.constrain(to: self)
    }

    init() {
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoardUIView: BoardProtocol {
    func getButton(at index: Int) -> GridButtonProtocol {
        return gridView.buttons[index]
    }
}
