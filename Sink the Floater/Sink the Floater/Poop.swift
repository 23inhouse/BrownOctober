//
//  Poop.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 18/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class Poop {

    var identifier: Int
    var data: [[Int]]
    var poopSize: Int
    var foundCounter = 0
    var isFound = false

    static var identiferFactory = 0

    func incrementFoundCounter() {
        self.foundCounter += 1

        if foundCounter == poopSize {
            self.isFound = true
        }
    }

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

        var poopSize = 0
        for row in data { for value in row { poopSize += value } }
        self.poopSize = poopSize
    }

}
