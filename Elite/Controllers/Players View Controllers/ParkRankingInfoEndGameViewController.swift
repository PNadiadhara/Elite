//
//  ParkRankingInfoEndGameViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 6/27/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class ParkRankingInfoEndGameViewController: UIViewController {
    

    
    @IBOutlet weak var nameOfPark: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var userRankingLabel: UILabel!
    @IBOutlet weak var rankingTableView: UITableView!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var doneButton: RoundedButton!
    @IBOutlet weak var sportLabel: UILabel!
    
    private var playerRanking = [GamerModel]() {
        didSet {
            DispatchQueue.main.async {
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        MultiPeerConnectivityHelper.shared.endSession()
        }
    
    func setupUI() {
        sportLabel.text = GameModel.gameName?.capitalized
        nameOfPark.text = GameModel.parkSelected
        DBService.findPlayersWinsAtPark(parkId: GameModel.parkId!, gamerId: TabBarViewController.currentGamer.gamerID, sport: GameModel.gameName!) { (wins) in
            self.winsLabel.text = "Wins: \(wins)"
        }
        DBService.findPlayersLossesAtPark(parkId: GameModel.parkId!, gamerId: TabBarViewController.currentGamer.gamerID, sport: GameModel.gameName!) { (loses) in
            self.userRankingLabel.text = "Losses: \(loses)"
        }
    }


    @IBAction func donePressed(_ sender: Any) {
        if MultiPeerConnectivityHelper.shared.role == .Host {
        guard let game = GameModel.game else {
            print("Game is nil")
            return
        }
        GameModel.clearGameModel(gameModel: game)
        }
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
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
