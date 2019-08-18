//
//  DragRecord.swift
//  Brown October
//
//  Created by Benjamin Lewis on 18/8/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

struct DragRecord {
    let view: BoardUIView
    var indexes = [Int]()

    func reversedIndexes() -> [Int] {
        return indexes.reversed()
    }

    mutating func storeIndex(at recognizer: UIPanGestureRecognizer) {
        let droppedAt = view.convert(recognizer.location(in: view), to: view)

        for tile in view.buttons {
            guard !indexes.contains(tile.index) else { continue }
            let frame = tile.superview!.convert(tile.frame, to: view)
            if frame.contains(droppedAt) {
                indexes.append(tile.index)
                break
            }
        }
    }

    init(view: BoardUIView) {
        self.view = view
    }
}
