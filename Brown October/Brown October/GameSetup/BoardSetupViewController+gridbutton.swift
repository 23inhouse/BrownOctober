//
//  BoardSetupViewController+gridbutton.swift
//  Brown October
//
//  Created by Benjamin Lewis on 19/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

extension BoardSetupViewController: GridButtonDelegate {
    func didTouchGridButton(_ sender: ValuableButton) {
        let index = sender.index

        guard let poop = board.poop(at: index) else { return }
        if ArrangedPoop(poop, board)?.rotate() ?? false {
            boardView.draw()
        }
    }
}

extension BoardSetupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension BoardSetupViewController: GridButtonDragDelegate {
    func didDragGridButton(_ recognizer: UIPanGestureRecognizer) {
        dragger.call(recognizer) { poop, index in
            for dragIndex in dragger.dragRecord.reversedIndexes() {
                guard let adjustment = board.gridUtility.calcXYAdjustment(from: index, to: dragIndex) else { continue }

                if ArrangedPoop(poop, board)?.move(by: adjustment) ?? false {
                    break
                }
            }
            boardView.draw()
            UserData.storePoopStains(board.poopStains)
        }
    }
}
