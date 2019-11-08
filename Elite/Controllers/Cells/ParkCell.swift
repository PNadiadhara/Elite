//
//  ParkCell.swift
//  Elite
//
//  Created by Leandro Wauters on 11/7/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class ParkCell: UITableViewCell {

    @IBOutlet weak var cellViewBackground: UIView!
    @IBOutlet weak var parkName: UILabel!
    @IBOutlet weak var medalImage: UIImageView!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    
    private let rankingHelper = RankingHelper()
    private let medalHelper = MedalsHelper()
    override func awakeFromNib() {
        super.awakeFromNib()
        cellViewBackground.layer.cornerRadius = 10
        cellViewBackground.layer.masksToBounds = true
        cellViewBackground.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        cellViewBackground.layer.borderWidth = 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with gamePlayed: GameModel) {
        parkName.text = gamePlayed.parkName
        sportLabel.text = gamePlayed.gameName.capitalized
        
        rankingHelper.findPlayerRanking(gamerId: GamerModel.currentGamer.gamerID, parkId: gamePlayed.parkId, sport: gamePlayed.gameName) { (error, ranking) in
            if let ranking = ranking {
                self.medalImage.image = self.medalHelper.getMedalImages(ranking: ranking)
                DBService.findPlayersWinsAtPark(parkId: gamePlayed.parkId, gamerId: GamerModel.currentGamer.gamerID, sport: gamePlayed.gameName) { (wins) in
                    DBService.findPlayersLossesAtPark(parkId: gamePlayed.parkId, gamerId: GamerModel.currentGamer.gamerID, sport: gamePlayed.gameName) { (losses) in
                        self.rankingLabel.text = "#\(ranking) W:\(wins) - L:\(losses)"
                        
                    }
                }
            }
        }
    }
}
