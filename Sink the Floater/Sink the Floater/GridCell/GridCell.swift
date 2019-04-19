//
//  gridCellCollectionViewCell.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 14/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol GridCellTouchDelegate {
    func didTouch(_ sender: GridCell)
}

class GridCell: UICollectionViewCell {

    var touchDelegate: GridCellTouchDelegate!

    @IBOutlet weak var button: UIButton!
    @IBAction func touchButton(_ sender: UIButton) {
        touchDelegate.didTouch(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(text: String, color: UIColor) {
        self.button.setTitle(text, for: UIControlState.normal)
        self.button.backgroundColor = color
    }
}
