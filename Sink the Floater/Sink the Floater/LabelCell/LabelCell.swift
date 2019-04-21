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

    func setData(text: String, color: UIColor, alpha: CGFloat) {
        self.label.text = text
        self.label.backgroundColor = color
        self.label.alpha = alpha
    }
}
