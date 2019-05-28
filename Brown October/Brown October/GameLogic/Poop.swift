//
//  Poop.swift
//  Brown October
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
        self.identiferFactory = 0
        return [poop1(), poop2(), poop3(), poop4(), poop5(), poop6()]
    }

    static func poop1(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([[1,1]])
    }

    static func poop2(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([[1,1,1]])
    }

    static func poop3(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([
            [0,1,0],
            [1,1,1]
            ])
    }

    static func poop4(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([[1,1,1,1]])
    }

    static func poop5(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([[1,1,1,1,1]])
    }

    static func poop6(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([
            [0,1,1,1],
            [1,1,1,0]
            ])
    }

    init(_ data: [[Int]]) {
        self.identifier = Poop.getUniqueIdentifier()
        self.data = data

        var poopSize = 0
        for row in data { for value in row { poopSize += value } }
        self.poopSize = poopSize
    }

}
