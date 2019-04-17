//
//  LabelCell.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 17/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class LabelCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(text: String) {
        self.label.text = text
    }
}
