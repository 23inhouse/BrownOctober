//
//  BoardSetupUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 23/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class BoardSetupUIView: UIView {
    let boardView: BoardUIView

    private func setupView() {
        addSubview(boardView)
    }

    private func setupConstraints() {
        boardView.constrain(to: self)
    }

    init<Decorator: BoardDecoratorProtocol>(boardDecorator: Decorator) {
        self.boardView = BoardUIView(with: boardDecorator)
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
