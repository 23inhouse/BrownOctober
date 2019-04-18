//
//  gridCellCollectionViewCell.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 14/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

protocol GridCellTouchDelegate {
    func didTouch()
}

class GridCell: UICollectionViewCell {

    var touchDelegate: GridCellTouchDelegate!

    @IBOutlet weak var button: UIButton!
    @IBAction func touchButton(_ sender: UIButton) {
        touchDelegate.didTouch()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(text: String) {
        self.button.setTitle(text, for: UIControlState.normal)
        if text == "💩" {
            self.button.backgroundColor = #colorLiteral(red: 0.9050404505, green: 0.7668028458, blue: 0.4155730222, alpha: 1)
        }
    }
}
