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
        if text == "💩" {
            self.label.text = text
//            self.label.backgroundColor = #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1)
        } else {
            self.label.text = "🌊"
            self.label.alpha = 0.5
        }
    }
}
