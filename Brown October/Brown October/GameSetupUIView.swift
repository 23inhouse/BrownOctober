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
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalSpacing
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

    let resetButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.setTitle("🚽\nNEW", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = button.titleLabel!.font.withSize(40)
        button.titleLabel!.numberOfLines = 2
        button.titleLabel!.textAlignment = .center
        return button
    }()

    let playButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.setTitle("💩\nPLAY", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = button.titleLabel!.font.withSize(40)
        button.titleLabel!.numberOfLines = 2
        button.titleLabel!.textAlignment = .center
        return button
    }()

    let boardView = BoardUIView()

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
        boardView.constrain()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
