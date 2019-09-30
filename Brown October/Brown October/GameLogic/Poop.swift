//
//  Poop.swift
//  Brown October
//
//  Created by Benjamin Lewis on 18/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

class Poop {

    private(set) var identifier: Int
    private(set) var data: [[Int]]
    private(set) var poopSize: Int
    private(set) var foundCounter = 0
    private(set) var isFound = false

    let flip: Bool

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

    static func pinchSomeOff(for rule: PlayRule = .brownOctober) -> [Poop] {
        self.identiferFactory = 0
        switch rule {
        case .american:
            return [poop2(), poop3(), poop3(), poop5(), poop6()]
        case .brownOctober:
            return [poop2(), poop3(), poop4(), poop5(), poop6(), poop7()]
        case .russian:
            return [
                poop1(), poop1(), poop1(), poop1(),
                poop2(), poop2(), poop2(),
                poop3(), poop3(),
                poop5()
            ]
        case .tetrazoid:
            return [poop5(), poop4(), poop8(), poop9(), poop10(), poop11()]
        }
    }

    static func poop1(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([[1]])
    }

    static func poop2(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([
            [1, 1],
            [0, 0],
            ])
    }

    static func poop3(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([[1, 1, 1]])
    }

    static func poop4(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([
            [1, 1, 1],
            [0, 1, 0],
            [0, 0, 0],
            ])
    }

    static func poop5(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([
            [0, 0, 0, 0],
            [1, 1, 1, 1],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            ])
    }

    static func poop6(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([[1, 1, 1, 1, 1]])
    }

    static func poop7(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([
            [0, 0, 0, 0],
            [0, 1, 1, 1],
            [1, 1, 1, 0],
            [0, 0, 0, 0],
            ], flip: true)
    }

    static func poop8(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([
            [1, 1],
            [1, 1],
            ], flip: false)
    }

    static func poop9(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([
            [0, 1, 1],
            [1, 1, 0],
            [0, 0, 0],
            ], flip: true)
    }

    static func poop10(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([
            [0, 0, 1],
            [1, 1, 1],
            [0, 0, 0],
            ])
    }

    static func poop11(_ ident: Int? = nil) -> Poop {
        if ident != nil { identiferFactory = ident! }

        return Poop([
            [0, 0, 0],
            [1, 1, 1],
            [0, 0, 1],
            ])
    }

    init(_ data: [[Int]], flip: Bool = false) {
        self.identifier = Poop.getUniqueIdentifier()
        self.data = data
        self.flip = flip

        var poopSize = 0
        for row in data { for value in row { poopSize += value } }
        self.poopSize = poopSize
    }

}
