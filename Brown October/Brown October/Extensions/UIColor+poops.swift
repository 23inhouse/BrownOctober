//
//  UIColor+poops.swift
//  Brown October
//
//  Created by Benjamin Lewis on 2/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(poop ident: Int) {

        let color: UIColor
        switch ident {
        case 1: color = #colorLiteral(red: 1, green: 0.8801414616, blue: 0.8755826288, alpha: 1)
        case 2: color = #colorLiteral(red: 0.9995340705, green: 0.9512020038, blue: 0.8813460202, alpha: 1)
        case 3: color = #colorLiteral(red: 0.950082893, green: 0.985483706, blue: 0.8672256613, alpha: 1)
        case 4: color = #colorLiteral(red: 0.88, green: 0.9984898767, blue: 1, alpha: 1)
        case 5: color = #colorLiteral(red: 0.88, green: 0.8864146703, blue: 1, alpha: 1)
        case 6: color = #colorLiteral(red: 1, green: 0.88, blue: 0.9600842213, alpha: 1)
        default: color = .white
        }

        self.init(cgColor: color.cgColor)
    }

}
