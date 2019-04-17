//
//  ViewController.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 9/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    func didTouch() {
        flushCount += 1
    }
}
