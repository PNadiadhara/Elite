//
//  ParkRankingInfoEndGameViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 6/27/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class ParkRankingInfoEndGameViewController: UIViewController {
    
    @IBOutlet weak var playerImage: UIImageView!
    
    @IBOutlet weak var nameOfPark: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var rankingTableView: UITableView!
    @IBOutlet weak var rankingLabel: UILabel!
    
    var parkId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        }
    
    func setupUI() {
        DBService.findPlayersWinsAtPark(parkId: parkId, gamerId: TabBarViewController.currentGamer.gamerID) { (wins) in
            self.winsLabel.text = "Wins: \(wins)"
        }
        DBService.findPlayersLossesAtPark(parkId: parkId, gamerId: TabBarViewController.currentGamer.gamerID) { (loses) in
            self.lossesLabel.text = "Losses: \(loses)"
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
