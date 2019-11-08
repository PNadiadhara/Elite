//
//  ProfileViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/12/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

enum GearIconStatus {
    case pressed
    case notPressed
}

enum ShowView {
    case games, parks, friends
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: CircularButton!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var userWinsLossesLabel: UILabel!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var settingsView: RoundedView!
    @IBOutlet weak var editProfileButton: RoundedButton!
    @IBOutlet weak var signOutButton: RoundedButton!
    @IBOutlet weak var deleteAccountButton: RoundedButton!
    @IBOutlet weak var gamesPlayedTableView: UITableView!
    @IBOutlet weak var gameButton: RoundedButton!
    @IBOutlet weak var parkButton: RoundedButton!
    @IBOutlet weak var friendsButton: RoundedButton!
    
    
    private var authservice = AppDelegate.authservice
    
    var userLocation = CLLocationCoordinate2D()
    private var gamer: GamerModel?
    private var showView: ShowView! {
        didSet {
            self.gamesPlayedTableView.reloadData()
        }
    }
    let gamePostViewContent = GamePostView()
    var friends = [GamerModel]()
    var parks = [GameModel]()
    private var gamesPlayed = [GameModel]() {
        didSet {
            DispatchQueue.main.async {
                self.gamesPlayedTableView.reloadData()
            }
        }
    }
    private var gearIconStatus: GearIconStatus = .notPressed
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showView = .games
        gamesPlayedTableView.delegate = self
        gamesPlayedTableView.dataSource = self
        gamesPlayedTableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        gamesPlayedTableView.register(UINib(nibName: "ParkCell", bundle: nil), forCellReuseIdentifier: "ParkCell")
        gamesPlayedTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        fetchCurrentUser()
        fetchPlayersGames()
    }

    @IBAction func settingsPressed(_ sender: UIButton) {
        if gearIconStatus == .notPressed{
            gearIconStatus = .pressed
            settingsView.isHidden = false
        } else {
            gearIconStatus = .notPressed
            settingsView.isHidden = true
        }
    }
    
    @IBAction func editProfileButtonPressed(_ sender: RoundedButton) {
    }
    
    
    @IBAction func signOutButtonPressed(_ sender: RoundedButton) {
            authservice.signOutAccount()
            showLoginView()
        
    }
    
    @IBAction func deleteAccountButtonPressed(_ sender: RoundedButton) {
        self.confirmAlert(title: "DELETE ACCOUNT", message: "Are you sure you want to delete your account?") { (action) in
            if let user = AppDelegate.authservice.getCurrentUser() {
                DBService.deleteAccount(user: GamerModel.currentGamer, completion: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    user.delete { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        
                        self.showLoginView()
                    }
                })

            }
        }
    }
    
    private func fetchCurrentUser() {
        guard let profileImageUrl = URL(string: GamerModel.currentGamer.profileImage!) else {return}
        profileImage.kf.setImage(with: profileImageUrl, for: .normal)
        fullnameLabel.text = GamerModel.currentGamer.username!
    }
    
    private func fetchPlayersGames() {
        DBService.fetchPlayersGamesPlayed(gamerId: GamerModel.currentGamer.gamerID) { (error, games) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let games = games {
                self.gamesPlayed = games.sorted{$0.gameEndTime!.stringToDate() > $1.gameEndTime!.stringToDate()}
                
                for park in self.gamesPlayed {
                    if !self.parks.contains(where: { (game) -> Bool in
                        game.parkName == park.parkName && game.gameName == park.gameName
                    }){
                        self.parks.append(park)
                    }
                }
                
            }
        }
    }
    
    func setGameButtonColor() {
        if showView == .games {
            gameButton.setTitleColor(.white, for: .normal)
            gameButton.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.737254902, alpha: 1)
        } else {
            gameButton.setTitleColor(#colorLiteral(red: 0, green: 0.4980392157, blue: 0.737254902, alpha: 1), for: .normal)
            gameButton.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1725490196, blue: 0.1843137255, alpha: 1)
        }
    }
    
    func setParkButtonColor() {
        if showView == .parks {
            parkButton.setTitleColor(.white, for: .normal)
            parkButton.backgroundColor = #colorLiteral(red: 0, green: 0.7077997327, blue: 0, alpha: 1)
        } else {
            parkButton.setTitleColor(#colorLiteral(red: 0, green: 0.7077997327, blue: 0, alpha: 1), for: .normal)
            parkButton.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1725490196, blue: 0.1843137255, alpha: 1)
        }
    }
    
    func setFriendButtonColor() {
        if showView == .friends {
            friendsButton.setTitleColor(.white, for: .normal)
            friendsButton.backgroundColor = #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1)
        } else {
            friendsButton.setTitleColor(#colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1), for: .normal)
            friendsButton.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1725490196, blue: 0.1843137255, alpha: 1)
        }
    }
    @IBAction func gameButtonPressed(_ sender: Any) {
        showView = .games
        setGameButtonColor()
        setParkButtonColor()
        setFriendButtonColor()
    }
    @IBAction func parkButtonPressed(_ sender: Any) {
        showView = .parks
        setGameButtonColor()
        setParkButtonColor()
        setFriendButtonColor()
    }
    
    @IBAction func friendsButtonPressed(_ sender: Any) {
        showView = .friends
        setGameButtonColor()
        setParkButtonColor()
        setFriendButtonColor()
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch showView {
        case .games:
            return gamesPlayed.count
        case .parks:
            return parks.count
        case .friends:
            return friends.count
        default:
            return 0
        }
        
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch showView {
        case .games:
            let gamePlayed = gamesPlayed[indexPath.row]
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else {return            UITableViewCell()}
            cell.setupCell(with: gamePlayed)
            return cell
        case .parks:
            let park = parks[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell", for: indexPath) as? ParkCell else {return UITableViewCell()}
            cell.setupCell(with: park)
            return cell
        default:
          print("")
        }

        
        return UITableViewCell()
        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.GamePostCellHeight
    }

}

