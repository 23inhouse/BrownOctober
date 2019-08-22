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
    func draw(boardView: ValuableBoard)
    func flush(boardView: ValuableBoard, ident: Int)
}

extension BoardDecoratorProtocol {
    typealias ButtonData = (ValuableButton, Tile) -> (String, UIColor, CGFloat)?

    fileprivate func updateButtons(boardView: ValuableBoard, closure: ButtonData) {
        for i in 0 ..< board.count {
            let button = boardView.getButton(at: i)
            let tile = board.tile(at: i)
            guard let (text, color, alpha) = closure(button, tile) else { continue }
            button.setData(text: text, color: color, alpha: alpha)
        }
    }
}

class BoardDecorator: BoardDecoratorProtocol {
    var board: Board

    func draw(boardView: ValuableBoard) {
        updateButtons(boardView: boardView) { (_, _) in return ("", .white, 1) }
    }

    func flush(boardView: ValuableBoard, ident: Int) {
        updateButtons(boardView: boardView) { (button, tile) in
            guard tile.poopIdentifier == ident else { return nil }
            (button as! GridUIButton).springy()
            return nil
        }
    }

    init(for board: Board) {
        self.board = board
    }
}

class ArrangeBoardDecorator: BoardDecorator {
    override func draw(boardView: ValuableBoard) {
        updateButtons(boardView: boardView) { (_, tile) in
            let poopIdentifier = tile.poopIdentifier
            let text = poopIdentifier > 0 ? "💩" : ""
            return (text, UIColor.init(poop: poopIdentifier), 1)
        }
    }
}

class HeatMapBoardDecorator: BoardDecorator {
    override func draw(boardView: ValuableBoard) {
        updateButtons(boardView: boardView) { (_, tile) in
            guard !tile.isFlushed && !tile.isFound else { return nil }
            let heat = tile.heat ?? 0
            let color: UIColor = UIColor(hue: 0.08, saturation: CGFloat(heat * heat * heat), brightness: CGFloat(1 - (heat * heat * heat) / 2), alpha: CGFloat(0.5 + (heat * heat * heat) / 2))
            return ("", color, 1)
        }
    }
}

class PoopBoardDecorator: BoardDecorator {
    override func draw(boardView: ValuableBoard) {
        updateButtons(boardView: boardView) { (_, tile) in
            let poopIdentifier = tile.poopIdentifier
            if poopIdentifier > 0 {
                let color: UIColor = tile.isFlushed ?  UIColor.init(poop: poopIdentifier) : .white
                let alpha: CGFloat = tile.isFlushed ? 1.0 : 0.5
                return ("💩", color, alpha)
            }

            return ("", .white, 1)
        }
    }
}

class PlayBoardDecorator: BoardDecorator {
    override func draw(boardView: ValuableBoard) {
        updateButtons(boardView: boardView) { (_, tile) in
            let poopIdentifier = tile.poopIdentifier
            if tile.isFound && tile.isFlushed {
                return ("💩", UIColor.init(poop: poopIdentifier), 1)
            }

            if tile.isFound {
                return ("💩", .white, 0.95)
            }

            if tile.isFlushed {
                return ("🌊", #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1), 0.55)
            }

            return ("", .white, 1)
        }
    }
}

class RevealBoardDecorator: BoardDecorator {
    override func draw(boardView: ValuableBoard) {
        updateButtons(boardView: boardView) { (_, tile) in
            let poopIdentifier = tile.poopIdentifier
            if poopIdentifier > 0 {
                let alpha: CGFloat = tile.isFound ? 1 : 0.15
                return ("💩", UIColor.init(poop: poopIdentifier), alpha)
            }

            if tile.isFlushed {
                return ("🌊", #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1), 0.55)
            }

            return ("", .white, 1)
        }
    }
}

class TeaseBoardDecorator: BoardDecorator {
    override func draw(boardView: ValuableBoard) {
        updateButtons(boardView: boardView) { (_, tile) in
            let poopIdentifier = tile.poopIdentifier
            if poopIdentifier > 0 {
                let alpha: CGFloat = tile.isFound ? 1 : 0.25
                return ("💩", UIColor.init(poop: poopIdentifier), alpha)
            }

            if tile.isFlushed {
                return ("🌊", #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1), 0.55)
            }

            return ("", .white, 1)
        }
    }
}
