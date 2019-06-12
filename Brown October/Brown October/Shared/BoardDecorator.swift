//
//  BoardDecorator.swift
//  Brown October
//
//  Created by Benjamin Lewis on 2/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol BoardDecoratorProtocol {
    var board: Board { get }
    func draw(boardView: BoardViewProtocol)
    func flush(boardView: BoardViewProtocol, ident: Int)
}

extension BoardDecoratorProtocol {
    typealias buttonData = (GridUIButton, Tile) -> (String, UIColor, CGFloat)?

    fileprivate func updateButtons(boardView: BoardViewProtocol, closure: buttonData) {
        for (i, tile) in board.tiles.enumerated() {
            let button = boardView.getButton(at: i) as! GridUIButton
            guard let (text, color, alpha) = closure(button, tile) else { continue }
            button.setData(text: text, color: color, alpha: alpha)
        }
    }
}

class BoardDecorator: BoardDecoratorProtocol {
    var board: Board

    func draw(boardView: BoardViewProtocol) {
        updateButtons(boardView: boardView) { (_, _) in return ("", .white, 1) }
    }

    func flush(boardView: BoardViewProtocol, ident: Int) {
        updateButtons(boardView: boardView) { (button, tile) in
            if tile.poopIdentifier != ident { return nil }

            tile.markAsFlushed()
            button.springy()

            let color = UIColor(poop: ident)
            return ("💩", color, 1)
        }
    }

    init(for board: Board) {
        self.board = board
    }
}

class PoopBoardDecorator: BoardDecorator {
    override func draw(boardView: BoardViewProtocol) {
        updateButtons(boardView: boardView) { (button, tile) in
            let text = tile.poopIdentifier > 0 ? "💩" : ""
            return (text, .white, 1)
        }
    }
}

class ArrangeBoardDecorator: BoardDecorator {
    override func draw(boardView: BoardViewProtocol) {
        updateButtons(boardView: boardView) { (button, tile) in
            let text = tile.poopIdentifier > 0 ? "💩" : ""
            let color = UIColor(poop: tile.poopIdentifier)
            return (text, color, 1)
        }
    }
}

class TeaseBoardDecorator: BoardDecorator {
    override func draw(boardView: BoardViewProtocol) {
        updateButtons(boardView: boardView) { (button, tile) in
            let tease = tile.poopIdentifier > 0 && !tile.isFound
            let color = tease ? UIColor(poop: tile.poopIdentifier) : .white
            return ("", color, 1)
        }
    }
}

class RevealBoardDecorator: BoardDecorator {
    override func draw(boardView: BoardViewProtocol) {
        updateButtons(boardView: boardView) { (button, tile) in
            let text = tile.isFound ? "💩" : tile.isFlushed ? "🌊" : " "
            let reveal = tile.poopIdentifier > 0 && (tile.isFlushed || !tile.isFound)
            let color = reveal ? UIColor(poop: tile.poopIdentifier) : .white
            let alpha: CGFloat = text == "🌊" ? 0.55 : 1
            return (text, color, alpha)
        }
    }
}

class HeatMapBoardDecorator: BoardDecorator {
    override func draw(boardView: BoardViewProtocol) {
        updateButtons(boardView: boardView) { (button, tile) in
            guard !tile.isFlushed && !tile.isFound else { return nil }
            let heat = tile.heat ?? 0
            let color: UIColor = UIColor(hue: 0.08, saturation: CGFloat(heat * heat * heat), brightness: CGFloat(1 - (heat * heat * heat) / 2), alpha: CGFloat(0.5 + (heat * heat * heat) / 2))
            button.heatMapLabel.backgroundColor = color
            return nil
        }
    }
}
