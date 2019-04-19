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
        if text == "💩" {
            self.label.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.7647058824, blue: 0.462745098, alpha: 1)
        }
    }
}
