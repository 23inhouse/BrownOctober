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

protocol GridCellProtocol {
    func touchButton(_ button: UIButton)
    func getButton() -> UIButton
}

class GridCell: UICollectionViewCell, GridCellProtocol {
    var touchDelegate: GridCellTouchDelegate!

    @IBOutlet weak var button: UIButton!
    @IBAction func touchButton(_ sender: UIButton) {
        if sender.currentTitle != "" { return }
        touchDelegate.didTouch(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(text: String, color: UIColor, alpha: CGFloat) {
        self.button.setTitle(text, for: UIControlState.normal)
        self.button.backgroundColor = color
        self.button.alpha = alpha
    }

    func getButton() -> UIButton {
        return self.button
    }
}
