//
//  AppDelegate.swift
//  Elite
//
//  Created by Pritesh Nadiadhara on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var authservice = AuthService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(PrivateInfoFile.GoogleMapsApiKey)
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        if let _ = AppDelegate.authservice.getCurrentUser() {
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
<<<<<<< HEAD
            tab.viewControllers = controller
=======
            
            tab.viewControllers = controller.map{UINavigationController.init(rootViewController: $0)}
>>>>>>> 02c790906cff33ac7adbc0d583fc173c30b6d7ac
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = tab
            window?.makeKeyAndVisible()
            
        } else {
            let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            window?.rootViewController = UINavigationController(rootViewController: loginViewController)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

