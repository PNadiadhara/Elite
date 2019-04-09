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
    private var owner: GamerModel? {
        didSet {
            //updateProfileUI(user: owner!)
            //fetchOwnerPosts(user: owner!)
        }
    }
    private var gamer = [GamerModel]() {
        didSet {
            DispatchQueue.main.async {
                //self.profileTableView.reloadData()
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
//        profileTableView.tableHeaderView = profileHeaderView
//        profileTableView.dataSource = self
//        profileTableView.delegate = self
//        profileTableView.register(UINib(nibName: "ProfileHeaderView", bundle: nil), forCellReuseIdentifier: "ProfileHeaderView")
    }
    
    private func fetchCurrentUser() {
        guard let currentUser = authservice.getCurrentUser() else {
            print("No logged user")
            return
        }
        //DBService.fetchUser(userId: currentUser.uid) { [weak self] (error, owner) in
            //if let error = error {
                //self?.showAlert(title: "Error fetching account info", message: //error.localizedDescription)
            //} else if let owner = owner {
                //self?.owner = owner
            //}
        //}
    }
}
