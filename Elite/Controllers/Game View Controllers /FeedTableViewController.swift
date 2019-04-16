//
//  FeedTableViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    var feedHeaderView = FeedHeaderView ()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        tableView.register(UINib(nibName: "TwoVsTwoFeedCell", bundle: nil), forCellReuseIdentifier: "TwoVsTwoFeedCell")
        tableView.register(UINib(nibName: "FiveVsFiveFeedCell", bundle: nil), forCellReuseIdentifier: "FiveVsFiveFeedCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let sport = sports[indexPath.row]
//        switch sport.gameType {
//        case "1 vs. 1":
//            return 175
//        case "2 vs. 2":
//            return 300
//        case "5 vs. 5":
//            return 460
//        default:
//            return 100
//        }
//    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        feedHeaderView.titleLabel.text = "Feed" //Park name
        return feedHeaderView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height * 0.20
    }
    
}

