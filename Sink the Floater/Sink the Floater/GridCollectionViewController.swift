//
//  GridDataSourceCollectionViewController.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 15/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GridCell"

protocol GridCollectionTouchDelegate {
    func didTouch()
}

class GridCollectionViewController: UICollectionViewController {

    var touchDelegate: GridCollectionTouchDelegate!

    let cellData = [
        "  ","  ","  ","  ","  ","  ","  ","  ","  ","  ",
        "  ","💩","🌊","  ","🌊","  ","💩","💩","💩","🌊",
        "🌊","💩","  ","  ","  ","  ","🌊","🌊","  ","💩",
        "🌊","  ","🌊","  ","  ","🌊","  ","💩","  ","💩",
        "  ","  ","  ","  ","  ","  ","💩","💩","🌊","💩",
        "  ","🌊","  ","  ","  ","🌊","🌊","💩","  ","💩",
        "  ","  ","  ","  ","🌊","  ","💩","🌊","  ","💩",
        "  ","🌊","🌊","  ","  ","🌊","💩","💩","🌊","  ",
        "  ","  ","🌊","🌊","  ","  ","💩","💩","  ","🌊",
        "  ","  ","💩","💩","💩","💩","  ","💩","  ","  "
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "GridCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GridCell
        cell.touchDelegate = self
        cell.setData(text: self.cellData[indexPath.row])

        return cell
    }
}

extension GridCollectionViewController: GridCellTouchDelegate {
    func didTouch() {
        touchDelegate.didTouch()
    }
}



