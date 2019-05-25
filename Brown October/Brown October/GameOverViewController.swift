//
//  GameOverViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 24/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    static let winText = "💩🏆🥈🌈"
    static let looseText = "🧻🧴🧽🚿🍎🥦📱🖕"

    lazy var humanPlayer: Player = Player.human
    lazy var computerPlayer: Player = Player.computer
    lazy var winner: Player = Player.human

    var mainView: GameOverUIView { return self.view as! GameOverUIView }

    @objc private func touchButton() {
        self.performSegue(withIdentifier: "PlayAgain", sender: self)
    }


    private func setupView() {
        let text = winner.isHuman ? type(of: self).winText : type(of: self).looseText
        self.view = GameOverUIView(text: text)

        mainView.button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)

        set(buttons: &mainView.computerButtons, from: computerPlayer)
        set(buttons: &mainView.humanButtons, from: humanPlayer)
    }

    private func set(buttons: inout [GridUIButton], from player: Player) {
        for (i, tile) in player.board.tiles.enumerated() {
            let text = tile.isFound ? "💩" : ""
            let color:UIColor = tile.isFlushed ? .blue : .white
            buttons[i].setData(text: text, color: color, alpha: 1)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}
