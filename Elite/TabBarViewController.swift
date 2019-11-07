//
//  TabBarViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class TabBarViewController: UITabBarController {


    let map = MapViewController()
    let feed = FeedTableViewController()
    let create = CreateGameViewController()
    let play = HostJoinGameViewController()
    let profile = ProfileViewController.init(nibName: "ProfileViewController", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.title = "Map"
        map.tabBarItem = UITabBarItem.init(title: "Map", image: UIImage(named: "map_marker"), tag: 0)
        feed.tabBarItem = UITabBarItem.init(title: "Feed", image: UIImage(named: "list"), tag: 3)
        play.title = "Host/Join Game"
        play.tabBarItem = UITabBarItem.init(title: "Play!", image: UIImage(named: "create_new"), tag: 2)
        profile.title = "Profile"
        profile.tabBarItem = UITabBarItem.init(title: "Profile", image: UIImage(named: "user_male"), tag: 4)

        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.06714623421, green: 0.07300782949, blue: 0.07880545408, alpha: 1)
        UITabBar.appearance().tintColor = #colorLiteral(red: 1, green: 0.3882352941, blue: 0.09803921569, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        viewControllers = [map, play, profile]
    }


 
}
