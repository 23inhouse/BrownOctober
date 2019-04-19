//
//  Poop.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 18/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

struct Poop {

    var identifier: Int
    var data: [[Int]]
//    var direction = 0 // 0:right, 1:down, 2:left, 3:up

    static var identiferFactory = 0

    static func getUniqueIdentifier() -> Int {
        identiferFactory += 1
        return identiferFactory
    }

    static func pinchSomeOff() -> [Poop] {
        var poops = [Poop]()

        poops.append(Poop([[1,1]]))
        poops.append(Poop([[1,1,1]]))
        poops.append(Poop([
            [0,1,0],
            [1,1,1]
        ]))
        poops.append(Poop([[1,1,1,1]]))
        poops.append(Poop([[1,1,1,1,1]]))
        poops.append(Poop([
            [0,1,1,1],
            [1,1,1,0]
        ]))

        return poops
    }

    init(_ data: [[Int]]) {
        self.identifier = Poop.getUniqueIdentifier()
        self.data = data
    }

}
