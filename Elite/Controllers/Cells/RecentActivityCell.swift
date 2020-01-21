//
//  RecentActivityCell.swift
//  Elite
//
//  Created by Leandro Wauters on 11/8/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class RecentActivityCell: UITableViewCell {

    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var playerOneImage: CircularImageView!
    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoImage: CircularImageView!
    @IBOutlet weak var playerTwoLabel: UILabel!
    @IBOutlet weak var gameDate: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with game: GameModel) {
        sportLabel.text = game.gameName.capitalized
        gameDate.text = game.gameEndTime
        let players = game.players
        var gamers = [GamerModel]()
        DBService.fetchGamer(gamerID: players[0]) { (error, gamer) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            if let playerOne = gamer {
                gamers.append(playerOne)
                DBService.fetchGamer(gamerID: players[1]) { (error, gamer) in
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                    if let playerTwo = gamer {
                        gamers.append(playerTwo)
                        if (game.losers?.contains(gamers[0].gamerID))! {
                            self.playerOneImage.alpha = 0.3
                            self.playerTwoImage.alpha = 1
                        } else {
                            self.playerOneImage.alpha = 1
                            self.playerTwoImage.alpha = 0.3
                        }
                        let playerOne = gamers[0]
                        let playerTwo = gamers[1]
                        self.playerOneLabel.text = playerOne.username
                        self.playerTwoLabel.text = playerTwo.username
                        guard let playerOneUrl = URL(string: playerOne.profileImage!) else {return}
                        guard let playerTwoUrl = URL(string: playerTwo.profileImage!) else {return}
                        self.playerOneImage.kf.setImage(with: playerOneUrl)
                        self.playerTwoImage.kf.setImage(with: playerTwoUrl)
                    }
                }
            }
        }
        

        

        
    }
    
}
