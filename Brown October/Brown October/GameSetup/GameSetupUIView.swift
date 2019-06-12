//
//  GameSetupUIView.swift
//  Brown October
//
//  Created by Benjamin Lewis on 25/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameSetupUIView: UIView {

    let layoutView: UIStackView = {
        let view = UIStackView()
        view.axis = UIView.longAxis
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()

    let emptySpaceView = UIView()

    let buttonsLayoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()

    lazy var resetButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.setTitle("🚽\nNEW", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = button.titleLabel!.font.withSize(buttonFontSize)
        button.titleLabel!.numberOfLines = 2
        button.titleLabel!.textAlignment = .center
        return button
    }()

    lazy var playButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.setTitle("💩\nPLAY", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = button.titleLabel!.font.withSize(buttonFontSize)
        button.titleLabel!.numberOfLines = 2
        button.titleLabel!.textAlignment = .center
        return button
    }()

    let boardView: BoardUIView

    let buttonFontSize: CGFloat = {
        let landscape = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        let divisor: CGFloat = landscape ? 18 : 9
        return UIScreen.main.bounds.width / divisor
    }()

    private func setupView() {
        backgroundColor = .white

        addSubview(layoutView)
        layoutView.addArrangedSubview(emptySpaceView)

        layoutView.addArrangedSubview(buttonsLayoutView)
        buttonsLayoutView.addArrangedSubview(resetButton)
        buttonsLayoutView.addArrangedSubview(playButton)
        layoutView.addArrangedSubview(boardView)
    }

    private func setupConstraints() {
        layoutView.constrain(to: self.safeAreaLayoutGuide)
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
