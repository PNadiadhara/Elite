//
//  ProfileViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class ProfileViewController: UIViewController {
    

    private lazy var profileHeaderView: ProfileHeaderView = {
        let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        return headerView
    }()
    
    private lazy var profileView: ProfileView = {
        let profile = ProfileView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        return profile
    }()
    
    
    private var authservice = AppDelegate.authservice
    var userLocation = CLLocationCoordinate2D()
    
    private var gamer: GamerModel? {
        didSet {
            //updateProfileUI(user: owner!)
            //fetchOwnerPosts(user: owner!)
        }
    }
    private var gameCreator = [GamerModel]() {
        didSet {
            DispatchQueue.main.async {
                self.profileView.profileTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //profileHeaderView.delegate = self
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCurrentUser()
    }
    
    private func configureTableView() {
//        profileTableView.dataSource = self
//        profileTableView.delegate = self
        profileView.profileTableView.tableHeaderView = profileHeaderView
        profileView.profileTableView.register(UINib(nibName: "ProfileView", bundle: nil), forCellReuseIdentifier: "ProfileView")
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

//extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return gameCreator.count
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = profileView.profileTableView.dequeueReusableCell(withIdentifier: "ProfileView", for: indexPath) as? ProfileView else {
//            fatalError("ProfileView not found")
//        }
//            return cell
//        }
//
//
    //}
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "Segue to JobPostDetail", sender: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }


//extension ProfileViewController: ProfileHeaderViewDelegate {
//    func willSignOutCurrentUser(_ profileHeaderView: ProfileHeaderView) {
//        authservice.signOutAccount()
//        showLoginView()
//    }
//
//    func willEditUsersProfile(_ profileHeaderView: ProfileHeaderView) {
//        <#code#>
//    }
//
//    func willDeleteAccount(_ profileHeaderView: ProfileHeaderView) {
//        <#code#>
//    }
//
//    func willRequestMatch(_ profileHeaderView: ProfileHeaderView) {
//        <#code#>
//    }
//
//    func willAddFriends(_ profileHeaderView: ProfileHeaderView) {
//        <#code#>
//    }
//
//    func willEditProfile(profileHeaderView: ProfileHeaderView) {
//        performSegue(withIdentifier: "Segue to EditOwnerProfile", sender: nil)
//    }
//}
