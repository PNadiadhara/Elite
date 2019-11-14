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
    @IBOutlet weak var doneButton: RoundedButton!
    @IBOutlet weak var sportLabel: UILabel!
    
    let rankingHelper = RankingHelper()
    let medalHelper = MedalsHelper()
    private var playerRanking = [GamerModel]() {
        didSet {
            DispatchQueue.main.async {
                self.rankingTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        rankingTableView.register(UINib(nibName: "PlayerCell", bundle: nil), forCellReuseIdentifier: "PlayerCell")
        MultiPeerConnectivityHelper.shared.endSession()
        }
    
    func setupUI() {
        sportLabel.text = GameModel.gameName?.capitalized
        nameOfPark.text = GameModel.parkSelected
        DBService.findPlayersWinsAtPark(parkId: GameModel.parkId!, gamerId: GamerModel.currentGamer.gamerID, sport: GameModel.gameName!) { (wins) in
            
            DBService.findPlayersLossesAtPark(parkId: GameModel.parkId!, gamerId: GamerModel.currentGamer.gamerID, sport: GameModel.gameName!) { (loses) in
                self.winsLabel.text = "Wins: \(wins) Losses: \(loses)"
            }
        }

        rankingHelper.findPlayerRanking(gamerId: GamerModel.currentGamer.gamerID, parkId: GameModel.parkId!, sport: GameModel.gameName!) { [weak self] error, ranking in
            if let error = error {
                self?.showAlert(title: "Error finding rankin", message: error.localizedDescription)
            }
            if let ranking = ranking {
                self?.userRankingLabel.text = "\(ranking)."
            }
        }
        rankingHelper.findRankingByPark(parkId: GameModel.parkId!, sport: GameModel.gameName!) { [weak self] rankedGamers, error in
            if let error = error {
                self?.showAlert(title: "Error finding ranking", message: error.localizedDescription)
            }
            if let rankedGamers = rankedGamers {
                self?.playerRanking = rankedGamers
            }
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
        self.navigationController?.popToRootViewController(animated: true)
    }

}

extension ParkRankingInfoEndGameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerRanking.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerCell else {
            fatalError()
        }
        let player = playerRanking[indexPath.row]
        let ranking = indexPath.row + 1
        cell.rankingLabel.text = ranking.description
        cell.userName.text = player.username
        if let profileImageURL = URL(string: player.profileImage!) {
            cell.profileImage.kf.setImage(with: profileImageURL)
        }
        
        cell.medalImage.image = medalHelper.getMedalImages(ranking: ranking)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
