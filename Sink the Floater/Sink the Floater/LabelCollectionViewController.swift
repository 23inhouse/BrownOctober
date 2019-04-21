//
//  GridDataSourceCollectionViewController.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 15/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LabelCell"

class LabelCollectionViewController: UICollectionViewController {

    let cellData = [
        " "," "," "," "," "," "," "," "," "," "," "," "," "," "," ",
        " "," "," "," "," "," "," "," "," "," ","1"," "," "," "," ",
        " "," "," "," "," "," "," "," ","1"," ","1"," ","1"," "," ",
        " "," "," ","1"," ","1"," "," ","1"," ","1"," ","1","1"," ",
        " ","1"," ","1"," ","1","1"," ","1"," ","1"," ","1","1"," ",
        " ","1"," ","1"," ","1"," "," ","1"," ","1"," "," ","1"," ",
        " "," "," "," "," "," "," "," "," "," "," "," "," "," "," ",
        ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "LabelCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LabelCell
        var text = self.cellData[indexPath.row]
        var alpha: CGFloat

        if text == "1" {
            text = "💩"
            alpha = 1.0
        } else {
            text = ""
            alpha = 0.5
        }
        cell.setData(text: text, color: .white, alpha: alpha)


        return cell
    }
}
