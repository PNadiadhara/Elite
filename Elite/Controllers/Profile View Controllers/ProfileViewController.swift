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
    private var gameCreator = [GamerModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCurrentUser()
    }

    @IBAction func settingsPressed(_ sender: UIButton) {
        settingsView.isHidden = false
        dismiss(animated: true, completion: nil)
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
        guard let currentUser = authservice.getCurrentUser() else {
            print("No logged user")
            return
        }
        DBService.fetchGamer(gamerID: currentUser.uid) { [weak self] (error, gamer) in
            if let error = error {
                self?.showAlert(title: "Error fetching Gamer information", message: error.localizedDescription)
            } else if let gamer = gamer {
                self?.gamer = gamer
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameCreator.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = gamesPlayedTableView.dequeueReusableCell(withIdentifier: "UserFeedCell", for: indexPath) as? UserFeedCell else {
            fatalError("cell not found")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.GamePostCellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Segue to GamePostDetail", sender: indexPath)
    }
}

