//
//  GameSetupViewController.swift
//  Brown October
//
//  Created by Benjamin Lewis on 21/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GameSetupViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    var mainView: GameSetupUIView { return self.view as! GameSetupUIView }

    lazy var boardView = mainView.boardView
    lazy var boardDecorator: BoardDecoratorProtocol = ArrangeBoardDecorator(for: board)

    lazy var board: Board = Board.buildGameBoard()
    lazy var poops: [Poop] = board.poops
    lazy var dragButtons = [GridUIButton]()

    @objc func touchResetButton(_ sender: UIButton) {
        sender.springy()
        board.placePoopsRandomly()
        UserData.storePoopStains(board.poopStains)

        boardView.draw()
    }

    @objc func touchPlayButton(_ sender: UIButton) {
        sender.springy()
        UserData.storePoopStains(board.poopStains)
        coordinator?.playGame()
    }

    private func setupView() {
        self.view = GameSetupUIView(boardDecorator: boardDecorator)

        mainView.resetButton.addTarget(self, action: #selector(touchResetButton), for: .touchUpInside)
        mainView.playButton.addTarget(self, action: #selector(touchPlayButton), for: .touchUpInside)

        boardView.buttons.forEach { [weak self] (button) in
            button.gridButtonDelegate = self
            button.gridButtonDragDelegate = self
        }

        loadBoard()
        boardView.draw()
    }

    private func loadBoard() {
        let poopStains = UserData.retrievePoopStains()
        if poopStains.count > 0 {
            board.poopStains = poopStains
            board.placePoopStains()
        } else {
            board.placePoopsRandomly()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        switch traitCollection.horizontalSizeClass {
        case .compact:
            mainView.layoutView.axis = .vertical
            mainView.layoutView.distribution = .equalSpacing
            mainView.buttonsLayoutView.axis = .horizontal
        case .regular:
            mainView.layoutView.axis = .horizontal
            mainView.layoutView.distribution = .equalSpacing
            mainView.buttonsLayoutView.axis = .vertical
        case .unspecified:
            fallthrough
        @unknown default:
            mainView.layoutView.axis = .vertical
            mainView.layoutView.distribution = .equalSpacing
            mainView.buttonsLayoutView.axis = .horizontal
        }
    }
}

extension GameSetupViewController: GridButtonDelegate {
    func didTouchGridButton(_ sender: GridButtonProtocol) {
        guard sender.getText() != "" else { return }

        let button = sender as! GridUIButton
        let index = button.index

        let poopIdent = board.tiles[index].poopIdentifier
        let poop = poops[poopIdent - 1]

        if board.rotate(poop: poop) {
            UserData.storePoopStains(board.poopStains)
            boardView.draw()
        }
    }
}

extension GameSetupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension GameSetupViewController: GridButtonDragDelegate {
    func didDragGridButton(_ recognizer: UIPanGestureRecognizer) {
        let button = recognizer.view as! GridUIButton
        let poopIdentifier = board.tiles[button.index].poopIdentifier

        guard poopIdentifier > 0 else { return }

        if recognizer.state == .began {

            let indexes = board.tiles.enumerated().filter({ $0.element.poopIdentifier == poopIdentifier }).map({ $0.offset })

            let buttons = boardView.buttons.filter({ indexes.contains($0.index) })
            dragButtons = buttons.map({
                let dragButton:GridUIButton = GridUIButton(index: $0.index, borderWidth: $0.borderWidth)
                dragButton.setData(text: button.getText(), color: $0.backgroundColor!, alpha: 1)
                dragButton.frame = $0.frame
                dragButton.center = $0.superview!.convert(dragButton.center, to: view)
                dragButton.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                view.addSubview(dragButton)
                return dragButton
            })
        }

        if recognizer.state == .ended {
            let adjustment = calcAdjustment(recognizer: recognizer)
            move(poop: poopIdentifier, by: adjustment)
            dragButtons.forEach({$0.removeFromSuperview()})
        }

        if recognizer.state == .changed {
            let translation = recognizer.translation(in: view)

            for dragButton in dragButtons {
                guard let dragSuperView = dragButton.superview else { return }
                let frame = dragSuperView.convert(dragButton.frame, to: view)
                let boardFrame = boardView.superview!.convert(boardView.frame, to: view)
                guard boardFrame.contains(frame) else {
                    let adjustment = calcAdjustment(recognizer: recognizer)
                    move(poop: poopIdentifier, by: adjustment)
                    dragButtons.forEach({$0.removeFromSuperview()})
                    return
                }
            }
            dragButtons.forEach({
                $0.center = CGPoint(x: $0.center.x + translation.x, y: $0.center.y + translation.y)
            })
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }

    private func calcAdjustment(recognizer: UIPanGestureRecognizer) -> Int? {
        let button = recognizer.view as! GridUIButton
        let droppedAt = view.convert(recognizer.location(in: view), to: boardView)

        for tile in boardView.buttons {
            let frame = tile.superview!.convert(tile.frame, to: boardView)
            if frame.contains(droppedAt) {
                return tile.index - button.index
            }
        }
        return nil
    }

    private func move(poop poopIdentifier: Int, by adjustment: Int?) {
        guard let adjustment = adjustment else { return }

        let poop = board.poops[poopIdentifier - 1]
        let poopStain = board.poopStains[poopIdentifier]!
        guard let tileIndex = board.gridUtility.calcIndex(poopStain.x, poopStain.y) else { return }
        guard let (x, y) = board.gridUtility.calcXY(tileIndex + adjustment) else { return }

        if board.remove(poop: poop, x: poopStain.x, y: poopStain.y, direction: poopStain.direction, tiles: &board.tiles) {
            if board.place(poop: poop, x: x, y: y, direction: poopStain.direction, tiles: &board.tiles) {
                board.poopStains[poopIdentifier] = Board.PoopStain(x: x, y: y, direction: poopStain.direction)
                UserData.storePoopStains(board.poopStains)
                boardView.draw()
            } else {
                _ = board.place(poop: poop, x: poopStain.x, y: poopStain.y, direction: poopStain.direction, tiles: &board.tiles)
            }
        }
    }
}
