//
//  ViewController.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 9/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var game = SinkTheFloater()
    var grid: GridCollectionViewController!
    var labelGrid: LabelCollectionViewController!
    var flushCount = 0 {
        didSet {
            flushCountLabel.text = "Flushes: \(flushCount)"
        }
    }

    @IBOutlet weak var flushCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        grid.touchCellDelegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueGridCollectionViewController") { grid = (segue.destination as! GridCollectionViewController) }
        if (segue.identifier == "segueLabelCollectionViewController") { labelGrid = (segue.destination as! LabelCollectionViewController) }
    }
}

extension ViewController: GridCollectionTouchDelegate {
    func didTouchCell(_ sender: GridCell) {
        flushCount += 1

        let index = grid.collectionView!.indexPath(for: sender)![1]
        if let poop = game.findPoop(at: index) {
            sender.setData(text: "💩", color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), alpha: 1)
            poop.incrementFoundCounter()
            if poop.isFound {
                flushPoop(poop.identifier)
            }
            return
        }

        sender.setData(text: "🌊", color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), alpha: 0.5)
    }

    private func flushPoop(_ ident: Int) {
        for index in 0 ..< self.game.tiles.count {
            let tile = self.game.tiles[index]
            if tile.poopIdentifier != ident { continue }

            if let cell = grid.collectionView!.cellForItem(at: IndexPath(row: index, section: 0)) as! GridCell? {
                cell.setData(text: "💩", color: #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1), alpha: 1)
            }
        }

        for index in 0 ..< self.game.labelTiles.count {
            let tile = self.game.labelTiles[index]
            if tile.poopIdentifier != ident { continue }

            if let cell = labelGrid.collectionView!.cellForItem(at: IndexPath(row: index, section: 0)) as! LabelCell? {
                cell.setData(text: "💩", color: #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1), alpha: 1)
            }
        }
    }
}
