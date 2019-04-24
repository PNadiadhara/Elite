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
    @IBOutlet weak var addFriend: UIButton!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var deleteAccount: UIButton!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var authservice = AppDelegate.authservice
    
    var userLocation = CLLocationCoordinate2D()
    private var gamer: GamerModel?
    let gamePostViewContent = GamePostView()
    let achievementsViewContent = AchievementsView()
    let friendListViewContent = FriendListView()
    private var gameCreator = [GamerModel]()
    var views = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        views = [gamePostViewContent,achievementsViewContent, friendListViewContent]
        scrollView.delegate = self
        pageControl.numberOfPages = views.count
        pageControl.currentPage = 0
        pageControl.bringSubviewToFront(pageControl)
        setupSlideScrollView(views: views)
        gamePostViewContent.gamePostTableView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
        achievementsViewContent.achievementsTableView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
        friendListViewContent.friendListTableView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
        signOutButton.addTarget(self, action: #selector(self.settingsPressed(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCurrentUser()
    }
    
    private func setupSlideScrollView(views:[UIView]) {
        scrollView.frame = CGRect (x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        scrollView.contentSize = CGSize (width: view.frame.width * CGFloat(views.count), height: view.frame.height / 2)
        scrollView.isPagingEnabled = true
        for i in 0...views.count - 1 {
            views[i].frame = CGRect (x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height / 2)
            scrollView.addSubview(views[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage =  Int(pageIndex)
    }
    
    @IBAction func addFriendPressed(_ sender: UIButton) {
    }
    
    @IBAction func settingsPressed(_ sender: UIButton) {
        settingsView.isHidden = true
    }
    
    @IBAction func editProfileButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        func willSignOut(profileViewController: ProfileViewController) {
            authservice.signOutAccount()
            showLoginView()
        }
    }
    
    @IBAction func deleteAccountButtonPressed(_ sender: UIButton) {
        if let user = AppDelegate.authservice.getCurrentUser(){
            user.delete { (error) in
                if error != nil {
                    self.showAlert(title: "DELETE ACCOUNT", message: "Are you sure you want to delete your account?")
                }
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
        if tableView == gamePostViewContent.gamePostTableView{
            guard let cell = gamePostViewContent.gamePostTableView.dequeueReusableCell(withIdentifier: "UserFeedCell", for: indexPath) as? UserFeedCell else {
                return UITableViewCell()
            }
            
            let profileFeedCell = gameCreator[indexPath.row]
            cell.userText.text = "@" + (profileFeedCell.username)
            return cell
        }
        if tableView == achievementsViewContent.achievementsTableView {
            guard let cell = achievementsViewContent.achievementsTableView.dequeueReusableCell(withIdentifier: "UserFeedCell", for: indexPath) as? UserFeedCell else {
                return UITableViewCell()
            }
            
            let achievementsFeedCell = gameCreator[indexPath.row]
            cell.userText.text = "@" + (achievementsFeedCell.username)
            return cell

        }
        if tableView == friendListViewContent.friendListTableView {
            guard let cell = friendListViewContent.friendListTableView.dequeueReusableCell(withIdentifier: "UserFeedCell", for: indexPath) as? UserFeedCell else {
                return UITableViewCell()
            }
            
            let friendListFeedCell = gameCreator[indexPath.row]
            cell.userText.text = "@" + (friendListFeedCell.username)
            return cell

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

