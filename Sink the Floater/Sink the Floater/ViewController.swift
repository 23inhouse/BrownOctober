//
//  ViewController.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 9/4/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var game = SinkTheFloater()
    var grid: GridCollectionViewController!
    var labelGrid: LabelCollectionViewController!
    lazy var computer = ComputerPlayer(game: game, grid: grid, nextGuessClosure: ComputerPlayer.makeDelayedGuessClosure)

    var flushCount = 0 {
        didSet {
            flushCountLabel.text = "Flushes: \(flushCount)"
        }
    }
    var poopCount = 0 {
        didSet {
            poopCountLabel.text = "poops: \(poopCount)"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    @IBOutlet weak var flushCountLabel: UILabel!
    @IBOutlet weak var poopCountLabel: UILabel!

    @IBOutlet weak var scoreLabel: UILabel!

    @IBAction func touchResetButton(_ sender: UIButton) {
        resetGame()
    }

    @IBAction func touchComputerButton(_ sender: UIButton) {
        guard score == 0 || score == 60 else { return }

        resetGame()
        playGame()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        grid.touchCellDelegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueGridCollectionViewController") { grid = (segue.destination as! GridCollectionViewController) }
        if (segue.identifier == "segueLabelCollectionViewController") { labelGrid = (segue.destination as! LabelCollectionViewController) }
    }

    private func resetGrid() {
        for index in 0 ..< self.game.tiles.count {
            let tile = self.game.tiles[index]
            tile.poopIdentifier = 0

            if let cell = grid.collectionView!.cellForItem(at: IndexPath(row: index, section: 0)) as! GridCell? {
                cell.setData(text: "", color: .white, alpha: 1)
            }
        }
    }

    private func resetLabels() {
        for index in 0 ..< self.game.labelTiles.count {
            if let cell = labelGrid.collectionView!.cellForItem(at: IndexPath(row: index, section: 0)) as! LabelCell? {
                if let text = cell.label.text {
                    cell.setData(text: text, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), alpha: 1)
                }
            }
        }
    }
}

extension ViewController: GridCollectionTouchDelegate {
    func didTouchCell(_ sender: GridCell) {
        flushCount += 1

        let index = grid.collectionView!.indexPath(for: sender)![1]

        if let (_, poop) = game.wipe(at: index) {
            sender.setData(text: "💩", color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), alpha: 1)
            poopCount += 1
            score += 1

            if poop.isFound {
                score += 10 - poop.poopSize
                flushPoop(poop.identifier)
            }
            return
        }

        game.tiles[index].markAsFlushed()
        sender.setData(text: "🌊", color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), alpha: 0.5)
    }

    private func flushPoop(_ ident: Int) {
        let color: UIColor
        switch ident {
        case 1:
            color = #colorLiteral(red: 1, green: 0.8801414616, blue: 0.8755826288, alpha: 1)
        case 2:
            color = #colorLiteral(red: 0.9995340705, green: 0.9970265407, blue: 0.8813460202, alpha: 1)
        case 3:
            color = #colorLiteral(red: 0.950082893, green: 0.985483706, blue: 0.8672256613, alpha: 1)
        case 4:
            color = #colorLiteral(red: 0.88, green: 0.9984898767, blue: 1, alpha: 1)
        case 5:
            color = #colorLiteral(red: 0.88, green: 0.8864146703, blue: 1, alpha: 1)
        case 6:
            color = #colorLiteral(red: 1, green: 0.88, blue: 0.9600842213, alpha: 1)
        default:
            color = #colorLiteral(red: 0.7395828382, green: 0.8683537049, blue: 0.8795605965, alpha: 1)
        }
        for index in 0 ..< self.game.tiles.count {
            let tile = self.game.tiles[index]
            if tile.poopIdentifier != ident { continue }

            if let cell = grid.collectionView!.cellForItem(at: IndexPath(row: index, section: 0)) as! GridCell? {
                cell.setData(text: "💩", color: color, alpha: 1)
                tile.markAsFlushed()
            }
        }

        for index in 0 ..< self.game.labelTiles.count {
            let tile = self.game.labelTiles[index]
            if tile.poopIdentifier != ident { continue }

            if let cell = labelGrid.collectionView!.cellForItem(at: IndexPath(row: index, section: 0)) as! LabelCell? {
                cell.setData(text: "💩", color: color, alpha: 1)
            }
        }
    }

    private func playGame() {
        computer.play()
    }

    private func resetGame() {
        resetGrid()
        resetLabels()

        self.game = SinkTheFloater()
        self.computer = ComputerPlayer(game: game, grid: grid, nextGuessClosure: ComputerPlayer.makeDelayedGuessClosure)

        flushCount = 0
        poopCount = 0
        score = 0
    }
}
