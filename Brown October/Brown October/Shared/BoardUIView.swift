//
//  BoardUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class BoardUIView: UIView {

    var decorator: BoardDecoratorProtocol
    lazy var gridView = GridUIStackView(cols: 10, rows: 10, active: true)
    lazy var buttons = gridView.buttons

    func draw(with decorator: BoardDecoratorProtocol? = nil) {
        (decorator ?? self.decorator).draw(boardView: self as ValuableBoard)
    }

    func flush(ident: Int) {
        decorator.flush(boardView: self as ValuableBoard, ident: ident)
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

extension BoardUIView: PlayableBoard {
    func getButton(at index: Int) -> PlayableButton {
        return gridView.buttons[index]
    }
}

extension BoardUIView: SetupableBoard {
    func getButton(at index: Int) -> SetupableButton {
        return gridView.buttons[index]
    }
}

extension BoardUIView: TouchableBoard {
    func getButton(at index: Int) -> TouchableButton {
        return gridView.buttons[index]
    }
}

extension BoardUIView: ValuableBoard {
    func getButton(at index: Int) -> ValuableButton {
        return gridView.buttons[index]
    }
}
