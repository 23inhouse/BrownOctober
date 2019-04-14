//
//  gridCellCollectionViewCell.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 14/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {

    var tapHandler: (()->())?

    @IBOutlet weak var button: UIButton!
    @IBAction func touchButton(_ sender: UIButton) {
        tapHandler?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(text: String) {
        self.button.setTitle(text, for: UIControlState.normal)
    }
}
