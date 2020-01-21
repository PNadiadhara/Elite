//
//  FeedCellTableViewCell.swift
//  SelfSizingCellsTest
//
//  Created by Leandro Wauters on 4/5/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var parkLabel: UILabel!
    
    @IBOutlet weak var sportImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func setupView(){
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.layer.borderWidth = 0.5
    }

    func setupCell(with gamePlayed: GameModel) {
        let opponent = gamePlayed.players.filter { (player) -> Bool in
            player != GamerModel.currentGamer.gamerID
        }
        parkLabel.text = "@ \(gamePlayed.parkName)"
        DBService.fetchGamer(gamerID: opponent.first!) { (error, opponent) in

            if let opponent = opponent {
                
                if (gamePlayed.winners?.contains(GamerModel.currentGamer.gamerID))! {
                    self.titleLabel.text = "Won! Vs. \(opponent.username!)"
                } else {
                    self.titleLabel.text = "Lost Vs. \(opponent.username!)"
                }
            }
        }

       dateLabel.text = gamePlayed.gameEndTime
        if gamePlayed.gameName == GameName.basketball.rawValue {
            view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.6078431373, blue: 0.1450980392, alpha: 1)
            sportImage.image = UIImage(named: "basketballEmptyWhite")
        } else {
            view.backgroundColor = #colorLiteral(red: 0, green: 0.6754498482, blue: 0.9192627668, alpha: 1)
            sportImage.image = UIImage(named: "handballWhite")
        }
    }
}
