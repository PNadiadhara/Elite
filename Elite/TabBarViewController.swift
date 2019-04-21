//
//  TabBarViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Firebase
class TabBarViewController: UITabBarController {

    static var currentUser: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        InvitationListener.fetchForInvitationRequest(vc: self)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
         InvitationListener.fetchForInvitationRequest(vc: self)
    }
    static func setTabBarVC() -> UITabBarController{
        if let user = AppDelegate.authservice.getCurrentUser() {
            currentUser = user
        }
        let map = MapViewController()
        let feed = FeedTableViewController()
        let create = CreateGameViewController()
        let board = LeaderboardViewController()
        let profile = ProfileViewController.init(nibName: "ProfileViewController", bundle: nil)
        let tab = TabBarViewController()
        map.title = "Map"
        map.tabBarItem = UITabBarItem.init(title: "Map", image: UIImage(named: "map_marker"), tag: 0)
        feed.title = "Feed"
        feed.tabBarItem = UITabBarItem.init(title: "Feed", image: UIImage(named: "list"), tag: 1)
        create.title = "Create Game"
        create.tabBarItem = UITabBarItem.init(title: "Create Game", image: UIImage(named: "create_new"), tag: 2)
        board.title = "Leaderboard"
        board.tabBarItem = UITabBarItem.init(title: "Leaderboard", image: UIImage(named: "line_chart"), tag: 3)
        profile.title = "Profile"
        profile.tabBarItem = UITabBarItem.init(title: "Profile", image: UIImage(named: "user_male"), tag: 4)
        let controller = [map, board, create, feed, profile]
        tab.viewControllers = controller
        return tab
    }

}
