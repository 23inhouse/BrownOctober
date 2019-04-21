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
    }
}

extension ViewController: GridCollectionTouchDelegate {
    func didTouchCell(_ sender: GridCell) {
        flushCount += 1

        let index = grid.collectionView!.indexPath(for: sender)![1]
        if let poop = game.findPoop(at: index) {
            sender.setData(text: "💩", color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))
            poop.incrementFoundCounter()
            if poop.isFound {
                flushPoop(poop.identifier)
            }
            return
        }

        sender.setData(text: "🌊", color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))
        sender.button.alpha = 0.5
    }

    func flushPoop(_ ident: Int) {
        var cells = [GridCell]()

        for index in 0 ..< 100 {

            let tile = self.game.tiles[index]
            if tile.poopIdentifier != ident { continue }

            if let cell = grid.collectionView!.cellForItem(at: IndexPath(row: index, section: 0)) as! GridCell? {
                cells.append(cell)
            }
        }

        for cell in cells {
            cell.setData(text: "💩", color: #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1))
        }
    }
}
