//
//  ParkListViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import GoogleMaps
import MultipeerConnectivity

enum TypeOfList {
    case ParkList
    case AvailableGameList
}
class ParkListViewController: UIViewController {

    weak var parkDelegate: ParkListDelegate?
    
    var disabledIndexPathRows = [Int]()
    var googleMapsHelper = GoogleMapHelper()
    @IBOutlet weak var parkListTableView: UITableView!
    @IBOutlet weak var listTitleLabel: UILabel!
    
    public var basketBallCourts = [BasketBall]() {
        didSet {
            DispatchQueue.main.async {
                self.parkListTableView.reloadData()
            }
        }
    }
   // let multiPeerConnectivityHelper = MultiPeerConnectivityHelper()
    public var availableGames = [GamerModel]() {
        didSet {
            DispatchQueue.main.async {
                self.parkListTableView.reloadData()
            }
        }
    }
    public var basketBallResults = [BasketBall]()
    public var handBallCourts = [HandBall]()
    public var handBallResults = [HandBall](){
        didSet {
            DispatchQueue.main.async {
                self.parkListTableView.reloadData()
            }
        }
    }
    public var gameName: GameName!
    public var typeOfList = TypeOfList.AvailableGameList
    public var userLocation = CLLocation()
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        MultiPeerConnectivityHelper.shared.multipeerDelegate = self
        parkListTableView.dataSource = self
        parkListTableView.delegate = self

        switch typeOfList {
        case .AvailableGameList:
            listTitleLabel.text = "Select Player"
            parkListTableView.register(UINib(nibName: "LeaderboardCell", bundle: nil), forCellReuseIdentifier: "LeaderboardCell")
            parkListTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return
        case .ParkList:
            parkListTableView.register(UINib(nibName: "ParkInfoCell", bundle: nil), forCellReuseIdentifier: "ParkInfoCell")
            parkListTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            fetchClosestParks()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func fetchClosestParks() {
        if gameName == .basketball {
        basketBallResults = googleMapsHelper.getBasketBallParksNearMe(userLocation, basketBallCourts, range: MilesInMetersInfo.twoMiles).reversed()
        } else {
        handBallResults = googleMapsHelper.getHandBallParksNearMe(userLocation, handBallCourts, range: MilesInMetersInfo.twoMiles).reversed()
        }
    }
    @IBAction func tapPressed(){
        dismiss(animated: true)
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

extension ParkListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = Int()
        switch typeOfList {
            
        case .AvailableGameList:
            count = availableGames.count
        case .ParkList:
            if gameName == .basketball {
                count = basketBallResults.count
            } else {
                count = handBallResults.count
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        switch typeOfList {
        case .AvailableGameList:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as? LeaderboardCell else {return UITableViewCell()}
            let gameName = availableGames[indexPath.row]
            cell.userName.text = gameName.username
            cell.profileImage.kf.setImage(with: URL(string: gameName.profileImage!))
            cell.rankingLabel.text = ""
            if !GameRestrictionsHelper.test {
                GameRestrictionsHelper.checkFor3GamesADayLimit(gamersId: gameName.gamerID) { (error, restricted) in
                    if let error = error {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                    if let restricted = restricted {
                        if restricted {
                            self.disabledIndexPathRows.append(indexPath.row)
                            cell.restrictionView.isHidden = false
                        }
                    }
                }
            }

            
        case .ParkList:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParkInfoCell", for: indexPath) as? ParkInfoCell else {return UITableViewCell()}
            if gameName == .basketball {
                let court = basketBallResults[indexPath.row]
                cell.parkNameLabel.text = court.nameOfPlayground
                cell.parkAddressLabel.text = court.location
            } else {
                let court = handBallResults[indexPath.row]
                cell.parkNameLabel.text = court.nameOfPlayground
                cell.parkAddressLabel.text = court.location
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if typeOfList == .AvailableGameList{
            MultiPeerConnectivityHelper.shared.joinGame(joiningGame: true)
        }
        if typeOfList == .ParkList {
            if gameName == .basketball {
                let court = basketBallResults[indexPath.row]
                parkDelegate?.parkSelected(basketBall: court, handBall: nil)
            } else {
                let court = handBallResults[indexPath.row]
                parkDelegate?.parkSelected(basketBall: nil, handBall: court)
            }
          dismiss(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if disabledIndexPathRows.contains(indexPath.row) {
            return nil
        }
        return indexPath
    }
}

extension ParkListViewController: MultipeerConnectivityDelegate {
    func foundAdverstiser(availableGames: [GamerModel]) {
        
    }
    
    func playerWantsToJoinGame(player: GamerModel, handler: @escaping (Bool) -> Void) {
        
    }
    

    
    func countIsTrue() {
        
    }
    

    
    func receivedUserData(data: Data, role: String) {
        
    }
    
    func connected(to User: String) {
        
    }
    

    
    func acceptedInvitation() {
        
        let oneVsOne = OneVsOneViewController()
        self.navigationController?.pushViewController(oneVsOne, animated: true)
    }
    

    
    
}
