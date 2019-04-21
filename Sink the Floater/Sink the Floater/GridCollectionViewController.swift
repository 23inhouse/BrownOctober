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
    func didTouchCell(_ sender: GridCell)
}

class GridCollectionViewController: UICollectionViewController {

    var touchCellDelegate: GridCollectionTouchDelegate!

    let cellData = [
        "","","","","","","","","","",
        "","","","","","","","","","",
        "","","","","","","","","","",
        "","","","","","","","","","",
        "","","","","","","","","","",
        "","","","","","","","","","",
        "","","","","","","","","","",
        "","","","","","","","","","",
        "","","","","","","","","","",
        "","","","","","","","","",""
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

        let icon = self.cellData[indexPath.row]
        let color = icon == "💩" ? #colorLiteral(red: 0.9098039216, green: 0.7647058824, blue: 0.462745098, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

        cell.setData(text: self.cellData[indexPath.row], color: color)
        return cell
    }
}

extension GridCollectionViewController: GridCellTouchDelegate {
    func didTouch(_ sender: GridCell) {
        touchCellDelegate.didTouchCell(sender)
    }
}



