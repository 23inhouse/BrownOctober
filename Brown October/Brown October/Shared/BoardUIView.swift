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
                button.backgroundColor = getTileColor(for: tile.poopIdentifier)
            }
        }
    }

    func getTileColor(for ident: Int) -> UIColor {
        let color: UIColor
        switch ident {
        case 1: color = #colorLiteral(red: 1, green: 0.8801414616, blue: 0.8755826288, alpha: 1)
        case 2: color = #colorLiteral(red: 0.9995340705, green: 0.9512020038, blue: 0.8813460202, alpha: 1)
        case 3: color = #colorLiteral(red: 0.950082893, green: 0.985483706, blue: 0.8672256613, alpha: 1)
        case 4: color = #colorLiteral(red: 0.88, green: 0.9984898767, blue: 1, alpha: 1)
        case 5: color = #colorLiteral(red: 0.88, green: 0.8864146703, blue: 1, alpha: 1)
        case 6: color = #colorLiteral(red: 1, green: 0.88, blue: 0.9600842213, alpha: 1)
        default: color = .white
        }

        return color
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
