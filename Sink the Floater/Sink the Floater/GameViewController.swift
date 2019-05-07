//
//  GameViewController.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 4/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var poopView: PoopUIView!
    var boardView: BoardUIView!

    var remainingFlushLabel: ScoreUILabel!
    var foundPoopsLabel: ScoreUILabel!

    lazy var game = SinkTheFloater()
    lazy var computer = ComputerPlayer(game: game, board: boardView, nextGuessClosure: ComputerPlayer.makeDelayedGuessClosure)

    var remainingFlushCount = 99 {
        didSet {
            self.remainingFlushLabel.setScore(score: remainingFlushCount)
        }
    }

    var poopsFoundCount = 0 {
        didSet {
            self.foundPoopsLabel.setScore(score: poopsFoundCount)
        }
    }

    private func flushPoop(_ ident: Int) {
        let color: UIColor
        switch ident {
        case 1:
            color = #colorLiteral(red: 1, green: 0.8801414616, blue: 0.8755826288, alpha: 1)
        case 2:
            color = #colorLiteral(red: 0.9995340705, green: 0.9970265407, blue: 0.8813460202, alpha: 1)
        case 3:
            color = #colorLiteral(red: 0.950082893, green: 0.985483706, blue: 0.8672256613, alpha: 1)
        case 4:
            color = #colorLiteral(red: 0.88, green: 0.9984898767, blue: 1, alpha: 1)
        case 5:
            color = #colorLiteral(red: 0.88, green: 0.8864146703, blue: 1, alpha: 1)
        case 6:
            color = #colorLiteral(red: 1, green: 0.88, blue: 0.9600842213, alpha: 1)
        default:
            color = #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1)
        }
        for i in 0 ..< self.game.tiles.count {
            let tile = self.game.tiles[i]
            if tile.poopIdentifier != ident { continue }

            tile.markAsFlushed()

            let button = boardView.buttons[i]
            button.setData(text: "💩", color: color, alpha: 1)
        }

        for i in 0 ..< self.game.labelTiles.count {
            let tile = self.game.labelTiles[i]
            if tile.poopIdentifier != ident { continue }

            let button = poopView.buttons[i]
            button.setData(text: "💩", color: color, alpha: 1)
        }
    }

    private func resetGame() {
        resetBoard()
        resetLabels()

        self.game = SinkTheFloater()
        self.computer = ComputerPlayer(game: game, board: boardView, nextGuessClosure: ComputerPlayer.makeDelayedGuessClosure)

        remainingFlushCount = 99
        poopsFoundCount = 0
    }

    private func resetBoard() {
        for i in 0 ..< game.tiles.count {
            let button = boardView.buttons[i]
            button.setData(text: "", color: .white, alpha: 1)
        }
    }

    private func resetLabels() {
        for i in 0 ..< game.labelTiles.count {
            let text = game.labelTiles[i].poopIdentifier > 0 ? "💩" : ""
            let button = poopView.buttons[i]
            button.setData(text: text, color: .white, alpha: 1)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let boardView = BoardUIView(frame: view.frame)
        view.addSubview(boardView)
        boardView.constrainTo(view.safeAreaLayoutGuide)
        self.boardView = boardView
        for button in boardView.buttons {
            button.gridButtonDelegate = self
        }

        let poopView = PoopUIView(frame: view.frame)
        view.addSubview(poopView)
        poopView.constrainTo(boardView)
        self.poopView = poopView

        let menuView = MenuUIView(frame: view.frame)
        view.addSubview(menuView)
        menuView.constrainTo(boardView: boardView, poopView: poopView)
        menuView.newGameButtonDelegate = self
        menuView.solveGameButtonDelegate = self

        let scoreView = ScoreUIView(frame: view.frame)
        view.addSubview(scoreView)
        scoreView.constrainTo(mainView: view, poopView: poopView, menuView: menuView)
        self.remainingFlushLabel = scoreView.remaningFlushLabel
        self.foundPoopsLabel = scoreView.foundPoopsLabel

        resetBoard()
        resetLabels()
    }
}

extension GameViewController: GridButtonDelegate {
    func didTouchGridButton(_ sender: GridButtonProtocol) {

        let button = sender as! GridUIButton
        remainingFlushCount -= 1

        let index = button.index

        if let (_, poop) = game.wipe(at: index) {
            button.setData(text: "💩", color: .white, alpha: 1)
            poopsFoundCount += 1

            if poop.isFound {
                flushPoop(poop.identifier)
            }
            return
        }

        game.tiles[index].markAsFlushed()
        button.setData(text: "🌊", color: .white, alpha: 0.65)
    }
}

extension GameViewController: NewGameButtonDelegate {
    func didTouchNewGame() {
        resetGame()
    }
}

extension GameViewController: SolveGameButtonDelegate {
    func didTouchSolveGame() {
        resetGame()
        computer.play()
    }
}

