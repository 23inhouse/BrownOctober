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
    func draw(boardView: DisplayableBoard)
    func flush(boardView: DisplayableBoard, ident: Int)
}

extension BoardDecoratorProtocol {
    typealias ButtonData = (ValuableButton, Tile) -> (String, UIColor, CGFloat, [UIBorder.Side])?

    fileprivate func updateButtons(boardView: DisplayableBoard, closure: ButtonData) {
        for i in 0 ..< board.count {
            let button = boardView.getButton(at: i)
            let tile = board.tile(at: i)
            guard let (text, color, alpha, borders) = closure(button, tile) else { continue }
            button.setData(text: text, color: color, alpha: alpha)
            button.activate(sides: borders)
        }
    }

    fileprivate func findAdjacent(to index: Int) -> [UIBorder.Side] {
        let bridges: [(Direction, UIBorder.Side)] = [
            (.up, .top),
            (.left, .left),
            (.right, .right),
            (.down, .bottom),
        ]

        let directions = board.findAdjacentPoop(from: index)
        var borders = [UIBorder.Side]()

        for brigde in bridges {
            let (direction, border) = brigde

            if !directions.contains(direction) {
                borders.append(border)
            }
        }

        return borders
    }
}

class BoardDecorator: BoardDecoratorProtocol {
    var board: Board

    func draw(boardView: DisplayableBoard) {
        updateButtons(boardView: boardView) { (_, _) in return ("", .white, 1, []) }
    }

    func flush(boardView: DisplayableBoard, ident: Int) {
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
    override func draw(boardView: DisplayableBoard) {
        updateButtons(boardView: boardView) { (button, tile) in
            let poopIdentifier = tile.poopIdentifier
            let text = poopIdentifier > 0 ? "💩" : ""
            let index = button.index
            return (text, UIColor.init(poop: poopIdentifier), 1, findAdjacent(to: index))
        }
    }
}

class HeatMapBoardDecorator: BoardDecorator {
    override func draw(boardView: DisplayableBoard) {
        updateButtons(boardView: boardView) { (_, tile) in
            guard !tile.isFlushed && !tile.isFound else { return nil }
            let heat = tile.heat ?? 0
            let color: UIColor = UIColor(hue: 0.08, saturation: CGFloat(heat * heat * heat), brightness: CGFloat(1 - (heat * heat * heat) / 2), alpha: CGFloat(0.5 + (heat * heat * heat) / 2))
            return ("", color, 1, [])
        }
    }
}

class PoopBoardDecorator: BoardDecorator {
    override func draw(boardView: DisplayableBoard) {
        updateButtons(boardView: boardView) { (button, tile) in
            let poopIdentifier = tile.poopIdentifier
            if poopIdentifier > 0 {
                let color: UIColor = tile.isFlushed ?  UIColor.init(poop: poopIdentifier) : .white
                let alpha: CGFloat = tile.isFlushed ? 1.0 : 0.5
                let index = button.index
                return ("💩", color, alpha, findAdjacent(to: index))
            }

            return ("", .white, 1, UIBorder.sides)
        }
    }
}

class PlayBoardDecorator: BoardDecorator {
    override func draw(boardView: DisplayableBoard) {
        updateButtons(boardView: boardView) { (button, tile) in
            let index = button.index
            let poopIdentifier = tile.poopIdentifier
            if tile.isFound && tile.isFlushed {
                return ("💩", UIColor.init(poop: poopIdentifier), 1, findAdjacent(to: index))
            }

            if tile.isFound {
                return ("💩", .white, 0.95, UIBorder.sides)
            }

            if tile.isFlushed {
                return ("🌊", #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1), 0.55, UIBorder.sides)
            }

            return ("", .white, 1, UIBorder.sides)
        }
    }
}

class RevealBoardDecorator: BoardDecorator {
    override func draw(boardView: DisplayableBoard) {
        updateButtons(boardView: boardView) { (button, tile) in
            let index = button.index
            let poopIdentifier = tile.poopIdentifier
            if poopIdentifier > 0 {
                let alpha: CGFloat = tile.isFound ? 1 : 0.15
                return ("💩", UIColor.init(poop: poopIdentifier), alpha, findAdjacent(to: index))
            }

            if tile.isFlushed {
                return ("🌊", #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1), 0.55, UIBorder.sides)
            }

            return ("", .white, 1, UIBorder.sides)
        }
    }
}

class TeaseBoardDecorator: BoardDecorator {
    override func draw(boardView: DisplayableBoard) {
        updateButtons(boardView: boardView) { (button, tile) in
            let index = button.index
            let poopIdentifier = tile.poopIdentifier
            if poopIdentifier > 0 {
                let alpha: CGFloat = tile.isFound ? 1 : 0.25
                return ("💩", UIColor.init(poop: poopIdentifier), alpha, findAdjacent(to: index))
            }

            if tile.isFlushed {
                return ("🌊", #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1), 0.55, UIBorder.sides)
            }

            return ("", .white, 1, UIBorder.sides)
        }
    }
}
