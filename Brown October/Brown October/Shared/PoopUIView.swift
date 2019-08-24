//
//  PoopUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class PoopUIView: UIView {

    static let width = 7
    static let height = 7

    var decorator: BoardDecoratorProtocol

    lazy var gridView = GridUIStackView(cols: PoopUIView.width, rows: PoopUIView.height, active: false)
    lazy var buttons = gridView.buttons

    func draw() {
        decorator.draw(boardView: self)
    }

    func flush(ident: Int) {
        decorator.flush(boardView: self, ident: ident)
    }

    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.881449021, green: 0.9286234245, blue: 0.9327289993, alpha: 1)

        addSubview(gridView)
    }

    private func setupConstraints() {
        let constraintHeight = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1, constant: 0)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            constraintHeight,
            ])

        gridView.constrain(to: self)
    }

    init<Decorator: BoardDecoratorProtocol>(with decorator: Decorator? = nil) {
        self.decorator = decorator ?? BoardDecorator(for: Board.makeGameBoard())
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PoopUIView: DisplayableBoard {
    func getButton(at index: Int) -> DisplayableButton {
        return gridView.buttons[index]
    }
}
