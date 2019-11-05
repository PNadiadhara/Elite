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
    @IBOutlet weak var medalImage: UIImageView!
    
    let medalHelper = MedalsHelper()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
    }
    func setupCell(with player: GamerModel, indexPathRow: Int, parkId: String, sport: String) {
        var cellColor = UIColor()
        var fontColor = UIColor()
        switch indexPathRow {
        case 0:
            cellColor = #colorLiteral(red: 0.8823529412, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
            fontColor = .white
        case 1:
            cellColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 0.8823529412, alpha: 1)
            fontColor = .white
        case 2:
            cellColor = #colorLiteral(red: 0.1882352941, green: 0.8196078431, blue: 0.3450980392, alpha: 1)
            fontColor = .white
        default:
            cellColor = .white
            fontColor = .black
        }
        let ranking = (indexPathRow + 1)
        rankingLabel.textColor = fontColor
        userName.textColor = fontColor
        userWinsLosses.textColor = fontColor
        cellView.backgroundColor = cellColor
        rankingLabel.text = ranking.description
        medalImage.image = medalHelper.getMedalImages(ranking: ranking)
        userName.text = player.username
        userImage.image = nil
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
