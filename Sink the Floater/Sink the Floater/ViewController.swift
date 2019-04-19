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
        grid.touchDelegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueGridCollectionViewController") { grid = (segue.destination as! GridCollectionViewController) }
    }
}

extension ViewController: GridCollectionTouchDelegate {
    func didTouch(_ sender: GridCell) {
        let index = grid.collectionView!.indexPath(for: sender)![1]
        let poop = game.chooseTile(at: index)
        flushCount += 1

        if poop > 0 {
            sender.setData(text: "💩", color: #colorLiteral(red: 0.9098039216, green: 0.7647058824, blue: 0.462745098, alpha: 1))
        } else {
            sender.setData(text: "🌊", color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))
        }
    }
}
