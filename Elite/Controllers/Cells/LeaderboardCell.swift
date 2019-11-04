//
//  LeaderboardCell.swift
//  Elite
//
//  Created by Leandro Wauters on 11/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class LeaderboardCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userWinsLosses: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(with player: GamerModel, indexPathRow: Int, parkId: String, sport: String) {
        var cellColor = UIColor()
        var fontColor = UIColor()
        switch indexPathRow {
        case 0:
            cellColor = #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1)
            fontColor = .white
        case 1:
            cellColor = #colorLiteral(red: 0.2274509804, green: 0.4392156863, blue: 0.6549019608, alpha: 1)
            fontColor = .white
        case 2:
            cellColor = #colorLiteral(red: 0, green: 0.7077997327, blue: 0, alpha: 1)
            fontColor = .white
        default:
            cellColor = .white
            fontColor = .black
        }
        rankingLabel.textColor = fontColor
        userName.textColor = fontColor
        userWinsLosses.textColor = fontColor
        cellView.backgroundColor = cellColor
        rankingLabel.text = (indexPathRow + 1).description
        userName.text = player.username
        if let url = URL(string: player.profileImage ?? "") {
            userImage.kf.setImage(with: url)
        }
        DBService.findPlayersWinsAtPark(parkId: parkId, gamerId: player.gamerID, sport: sport) { (wins) in
            DBService.findPlayersLossesAtPark(parkId: parkId, gamerId: player.gamerID, sport: sport) { (losses) in
                self.userWinsLosses.text = "\(wins):\(losses)"
            }
        }
    }
}
