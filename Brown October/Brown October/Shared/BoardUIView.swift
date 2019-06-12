//
//  BoardUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 6/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol BoardViewProtocol: class {
    func getButton(at index: Int) -> GridButtonProtocol
}

class BoardUIView: UIView {

    var decorator: BoardDecoratorProtocol
    lazy var gridView = GridUIStackView(cols: 10, rows: 10, active: true)
    lazy var buttons = gridView.buttons

    func draw(with decorator: BoardDecoratorProtocol? = nil) {
        (decorator ?? self.decorator).draw(boardView: self)
    }

    func flush(ident: Int) {
        decorator.flush(boardView: self, ident: ident)
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

extension BoardUIView: BoardViewProtocol {
    func getButton(at index: Int) -> GridButtonProtocol {
        return gridView.buttons[index]
    }
}
