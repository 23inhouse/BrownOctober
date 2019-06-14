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

    lazy var board: Board = Board.makeGameBoard()
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
        let boardDecorator = ArrangeBoardDecorator(for: board)
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
        let button = sender as! GridUIButton
        let index = button.index

        guard sender.getText() != "" else {
            let poop = poops[0]
            if board.move(poop: poop, to: index) {
                boardView.draw()
            }

            return
        }

        let poopIdent = board.tile(at: index).poopIdentifier
        let poop = poops[poopIdent - 1]

        if board.rotate(poop: poop) {
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
        let poopIdentifier = board.tile(at: button.index).poopIdentifier

        guard poopIdentifier > 0 else { return }

        switch recognizer.state {
        case .began:
            let indexes = board.tileIndexes(for: poopIdentifier)

            dragButtons = boardView.buttons.filter({ indexes.contains($0.index) }).map(duplicateButton)
            dragButtons.forEach { view.addSubview($0) }
        case .changed:
            for dragButton in dragButtons {
                guard checkBounds(dragButton, recognizer) else {
                    if move(poopIdentifier, by: recognizer) {
                        UserData.storePoopStains(board.poopStains)
                        boardView.draw()
                    }
                    dragButtons.forEach { $0.removeFromSuperview() }
                    break
                }
            }

            let translation = recognizer.translation(in: view)
            dragButtons.forEach { translate($0, by: translation) }
            recognizer.setTranslation(CGPoint.zero, in: view)
        case .ended:
            if move(poopIdentifier, by: recognizer) {
                UserData.storePoopStains(board.poopStains)
                boardView.draw()
            }
            dragButtons.forEach { $0.removeFromSuperview() }
        default:
            print("Error: WTF at drag recognizer state")
        }
    }

    private func duplicateButton(_ button: GridUIButton) -> GridUIButton {
        let duplicate = GridUIButton(index: button.index, borderWidth: button.borderWidth)
        duplicate.setData(text: button.getText(), color: button.backgroundColor!, alpha: 1)
        duplicate.frame = button.frame
        duplicate.center = button.superview!.convert(duplicate.center, to: view)
        duplicate.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        return duplicate
    }

    private func checkBounds(_ dragButton: GridUIButton, _ recognizer: UIPanGestureRecognizer) -> Bool {
        guard let dragSuperView = dragButton.superview else { return false }
        let frame = dragSuperView.convert(dragButton.frame, to: view)
        let boardFrame = boardView.superview!.convert(boardView.frame, to: view)
        guard boardFrame.contains(frame) else { return false }

        return true
    }

    private func translate(_ button: GridUIButton, by translation: CGPoint) {
        button.center = CGPoint(x: button.center.x + translation.x, y: button.center.y + translation.y)
    }

    private func move(_ poopIdentifier: Int, by recognizer: UIPanGestureRecognizer) -> Bool {
        let poop = board.poops[poopIdentifier - 1]

        guard let adjustment = calcAdjustment(recognizer: recognizer) else { return false }
        guard board.move(poop: poop, by: adjustment) else { return false }

        return true
    }

    private func calcAdjustment(recognizer: UIPanGestureRecognizer) -> (Int, Int)? {
        let button = recognizer.view as! GridUIButton
        let droppedAt = view.convert(recognizer.location(in: view), to: boardView)

        for tile in boardView.buttons {
            let frame = tile.superview!.convert(tile.frame, to: boardView)
            if frame.contains(droppedAt) {
                return board.gridUtility.calcXYAdjustment(from: button.index, to: tile.index)
            }
        }
        return nil
    }
}
