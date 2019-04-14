//
//  ViewController.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 9/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let cellData = [
        "🌊","🌊","🌊","🌊","🌊","🌊","🌊","🌊","🌊","🌊",
        "🌊","💩","  ","🌊","  ","🌊","💩","💩","💩","  ",
        "  ","💩","🌊","🌊","🌊","🌊","  ","  ","🌊","💩",
        "  ","🌊","  ","🌊","🌊","  ","🌊","💩","🌊","💩",
        "🌊","🌊","🌊","🌊","🌊","🌊","💩","💩","  ","💩",
        "🌊","  ","🌊","🌊","🌊","  ","  ","💩","🌊","💩",
        "🌊","🌊","🌊","🌊","  ","🌊","💩","  ","🌊","💩",
        "🌊","  ","  ","🌊","🌊","  ","💩","💩","  ","🌊",
        "🌊","🌊","  ","  ","🌊","🌊","💩","💩","🌊","  ",
        "🌊","🌊","💩","💩","💩","💩","🌊","💩","🌊","🌊"
    ]

    var flushCount = 0 {
        didSet {
            flushCountLabel.text = "Flushes: \(flushCount)"
        }
    }

    @IBOutlet weak var gridCollectionView: UICollectionView!
    @IBOutlet weak var flushCountLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.gridCollectionView.dataSource = self
        self.gridCollectionView.register(UINib(nibName: "GridCell", bundle: nil), forCellWithReuseIdentifier: "GridCell")
    }
}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridCollectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell

        cell.setData(text: self.cellData[indexPath.row])
        cell.tapHandler = {
            self.flushCount += 1
        }

        return cell
    }
}
