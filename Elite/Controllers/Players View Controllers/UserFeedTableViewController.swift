//
//  UserFeedTableViewController.swift
//  SelfSizingCellsTest
//
//  Created by Leandro Wauters on 4/7/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class UserFeedTableViewController: UITableViewController {
    let feedHeaderView = FeedHeaderView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(UINib(nibName: "UserFeedCell", bundle: nil), forCellReuseIdentifier: "UserFeedCell")
        tableView.register(UINib(nibName: "TwoVsTwoFeedCell", bundle: nil), forCellReuseIdentifier: "TwoVsTwoFeedCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sport = sports[indexPath.row]
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserFeedCell", for: indexPath) as? UserFeedCell else {return UITableViewCell()}
            cell.userImage.image = UIImage(named: "manny")
            cell.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
            cell.userText.text = "Manny won 10 basketball games"
            cell.trophyImage.image = UIImage(named: "trophy")
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TwoVsTwoFeedCell", for: indexPath) as? TwoVsTwoFeedCell else {return UITableViewCell()}
            cell.backgroundColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            cell.view.backgroundColor = sport.color
            cell.sportImage.image = UIImage(named: sport.name)

            return cell
        default:
            return UITableViewCell()
        }

        
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 125
        case 1:
            return 300
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        feedHeaderView.titleLabel.text = "Feed"
        return feedHeaderView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    
    
    
}
