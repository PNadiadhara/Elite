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

enum Views {
    case gamePost
    case achievements
    case friendList
}

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profileImage: CircularButton!
    @IBOutlet weak var medalImage: CircularImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var requestMatch: UIButton!
    @IBOutlet weak var addFriend: UIButton!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var gamePostView: RoundedView!
    @IBOutlet weak var achievementsView: RoundedView!
    @IBOutlet weak var friendListView: RoundedView!
    
    private var authservice = AppDelegate.authservice
    
    var userLocation = CLLocationCoordinate2D()
    private var gamer: GamerModel?
    let gamePostViewContent = GamePostView()
    let achievementsViewContent = AchievementsView()
    let friendListViewContent = FriendListView()
    var typeOfViews: Views = .gamePost
    private var gameCreator = [GamerModel]()
    var views = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        configureTableViews()
        views = [gamePostViewContent,achievementsViewContent, friendListViewContent]
        setupViews(views: views)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCurrentUser()
    }
    func setupViews(views: [UIView]){
        for vieww in views {
        view.addSubview(vieww)
    vieww.translatesAutoresizingMaskIntoConstraints = false
        vieww.topAnchor.constraint(equalTo: achievementsView.bottomAnchor, constant: 20).isActive = true
        vieww.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vieww.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vieww.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        vieww.isHidden = true
        }
        views.first?.isHidden = false
    }
    
    private func configureTableViews() {
        //     gamePost.gamePostTableView.dataSource
        //     gamePost.gamePostTableView.delegate
        //     achievements.achievementsTableView.dataSource
        //     achievements.achievementsTableView.delegate
        //     friendList.friendListTableView.dataSource
        //     friendList.friendListTableView.delegate
        
        
    }
    
    private func commonInit() {
                let gamePostTap = UITapGestureRecognizer(target: self, action: #selector(gamePostHandleTap))
                gamePostView.addGestureRecognizer(gamePostTap)
        
                let achievementTap = UITapGestureRecognizer(target: self, action: #selector(achievementsHandleTap))
                achievementsView.addGestureRecognizer(achievementTap)
        
                let friendListTap = UITapGestureRecognizer(target: self, action: #selector(friendListHandleTap))
                friendListView.addGestureRecognizer(friendListTap)
        
    }
    
    @objc func gamePostHandleTap(_ sender: UITapGestureRecognizer) {
        typeOfViews = .gamePost
        views[0].isHidden = false
        views[1].isHidden = true
        views[2].isHidden = true
        
        print(typeOfViews)
    }
    
        @objc func achievementsHandleTap(_ sender: UITapGestureRecognizer) {
            typeOfViews = .achievements
            print(typeOfViews)
            views[0].isHidden = true
            views[1].isHidden = false
            views[2].isHidden = true
        }
    
        @objc func friendListHandleTap(_ sender: UITapGestureRecognizer) {
            typeOfViews = .friendList
            views[0].isHidden = true
            views[1].isHidden = true
            views[2].isHidden = false
        }
    
    
    
    @IBAction func requestMatchPressed(_ sender: UIButton) {
    }
    
    @IBAction func addFriendPressed(_ sender: UIButton) {
    }
    
    @IBAction func settingsPressed(_ sender: UIButton) {
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
        if tableView == gamePostViewContent.gamePostTableView{
            guard let cell = gamePostViewContent.gamePostTableView.dequeueReusableCell(withIdentifier: "UserFeedCell", for: indexPath) as? UserFeedCell else {
                return UITableViewCell()
                fatalError("UserFeedCell not found")
            }
            return cell
        }
        if tableView == achievementsViewContent.achievementsTableView {

        }
        if tableView == friendListViewContent.friendListTableView {
        }
       return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.GamePostCellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Segue to GamePostDetail", sender: indexPath)
    }
}
//


//    let testGamePostView = GamePostView.init(frame: UIScreen.main.bounds)
//
