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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: CircularButton!
    @IBOutlet weak var medalImage: CircularImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var settingsView: RoundedView!
    @IBOutlet weak var editProfileButton: RoundedButton!
    @IBOutlet weak var signOutButton: RoundedButton!
    @IBOutlet weak var deleteAccountButton: RoundedButton!
    @IBOutlet weak var gamesPlayedTableView: UITableView!

    
    private var authservice = AppDelegate.authservice
    
    var userLocation = CLLocationCoordinate2D()
    private var gamer: GamerModel?
    let gamePostViewContent = GamePostView()
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
        gamesPlayedTableView.delegate = self
        gamesPlayedTableView.dataSource = self
        gamesPlayedTableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
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
                DBService.deleteAccount(user: TabBarViewController.currentGamer, completion: { (error) in
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
        guard let profileImageUrl = URL(string: TabBarViewController.currentGamer.profileImage!) else {return}
        profileImage.kf.setImage(with: profileImageUrl, for: .normal)
        fullnameLabel.text = TabBarViewController.currentGamer.username!
    }
    
    private func fetchPlayersGames() {
        DBService.fetchPlayersGamesPlayed(gamerId: TabBarViewController.currentUser.uid) { (error, games) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let games = games {
                self.gamesPlayed = games
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesPlayed.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gamePlayed = gamesPlayed[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else {return            UITableViewCell()}
        let bluePlayer = gamePlayed.blueTeam.first!
        let redPlayer = gamePlayed.redTeam.first!
        cell.gameTimeLabel.text = gamePlayed.gameEndTime
        if gamePlayed.gameName == GameName.basketball.rawValue {
            cell.view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.6078431373, blue: 0.1450980392, alpha: 1)
        } else {
            cell.view.backgroundColor = #colorLiteral(red: 0, green: 0.6754498482, blue: 0.9192627668, alpha: 1)
        }
        DBService.fetchGamer(gamerID: bluePlayer) { (error, bluePlayer) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let bluePlayer = bluePlayer {
                cell.bluePlayerLabel.text = bluePlayer.username!
                if (gamePlayed.losers?.contains(bluePlayer.gamerID))! {
                    cell.user2Image.alpha = 0.5
                }
                guard let profileImageURL = URL(string: bluePlayer.profileImage!) else {
                    print("No user image")
                    return
                }
                cell.user2Image.kf.setImage(with: profileImageURL)
            }
            
            
        }
        DBService.fetchGamer(gamerID: redPlayer) { (error, redPlayer) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let redPlayer = redPlayer {
                cell.redPlayerLabel.text = redPlayer.username!
                if (gamePlayed.losers?.contains(redPlayer.gamerID))! {
                    cell.user1Image.alpha = 0.5
                }
                guard let profileImageURL = URL(string: redPlayer.profileImage!) else {
                    print("No user image")
                    return
                }
                cell.user1Image.kf.setImage(with: profileImageURL)
            }
            
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.GamePostCellHeight
    }

}

