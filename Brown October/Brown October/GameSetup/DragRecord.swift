//
//  DragRecord.swift
//  Brown October
//
//  Created by Benjamin Lewis on 26/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol DragableTile {
    var index: Int { get }
    func contains(point: CGPoint) -> Bool
}

struct DragRecord {
    var tiles: [DragableTile]

    private var indexes = [Int]()

    func Indexes() -> [Int] {
        return indexes.reversed()
    }

    mutating func storeIndex(at droppedAt: CGPoint) {
        for tile in tiles {
            guard !indexes.contains(tile.index) else { continue }
            if tile.contains(point: droppedAt) {
                indexes.append(tile.index)
                break
            }
        }
    }

    init(tiles: [DragableTile]) {
        self.tiles = tiles
    }
}

//struct DragRecord {
//    let view: BoardUIView
//
//    var indexes = [Int]()
//
//    func Indexes() -> [Int] {
//        return indexes.reversed()
//    }
//
//    mutating func storeIndex(at droppedAt: CGPoint, at recognizer: UIPanGestureRecognizer) {
//        let droppedAt2 = view.convert(recognizer.location(in: view), to: view)
//
//        print(droppedAt, droppedAt2)
//        for tile in view.buttons {
//            guard !indexes.contains(tile.index) else { continue }
//            let frame = tile.superview!.convert(tile.frame, to: view)
//            if frame.contains(droppedAt) {
//                indexes.append(tile.index)
//                break
//            }
//        }
//    }
//
//    init(view: BoardUIView) {
//        self.view = view
//    }
//}
