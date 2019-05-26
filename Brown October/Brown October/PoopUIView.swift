//
//  PoopUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class PoopUIView: UIView {

    let width = 9
    let height = 5

    lazy var gridView = GridUIStackView(cols: width, rows: height, active: false)
    lazy var buttons = gridView.buttons

    lazy var foundPoops: Board = {
        var foundPoops = Board(width: width, height: height, poops: Poop.pinchSomeOff())
        let poops = foundPoops.poops

        _ = foundPoops.placePoop(poops[0], x: 5, y: 0, direction: 0, tiles: &foundPoops.tiles, check: false)
        _ = foundPoops.placePoop(poops[1], x: 4, y: 2, direction: 0, tiles: &foundPoops.tiles, check: false)
        _ = foundPoops.placePoop(poops[2], x: 3, y: 0, direction: 2, tiles: &foundPoops.tiles, check: false)
        _ = foundPoops.placePoop(poops[3], x: 3, y: 4, direction: 0, tiles: &foundPoops.tiles, check: false)
        _ = foundPoops.placePoop(poops[4], x: 8, y: 0, direction: 1, tiles: &foundPoops.tiles, check: false)
        _ = foundPoops.placePoop(poops[5], x: 0, y: 1, direction: 1, tiles: &foundPoops.tiles, check: false)

        return foundPoops
    }()

    func constrain() {
        let constraintHeight = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 0.555, constant: 0)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            constraintHeight,
            ])

        gridView.constrain(to: self)
    }

    func reset() {
        for (i, tile) in foundPoops.tiles.enumerated() {
            let text = tile.poopIdentifier > 0 ? "💩" : ""
            let button = gridView.buttons[i]
            button.setData(text: text, color: .white, alpha: 1)
        }
    }

    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.881449021, green: 0.9286234245, blue: 0.9327289993, alpha: 1)

        addSubview(gridView)
    }

    init() {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
