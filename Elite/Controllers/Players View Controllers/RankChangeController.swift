//
//  RankChangeController.swift
//  Elite
//
//  Created by Pritesh Nadiadhara on 5/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class RankChangeController: UIViewController {

    @IBOutlet var playerImageView: CircularRedImageView!
    @IBOutlet var playerUserName: UILabel!
    @IBOutlet var currentRankScore: UILabel!
    @IBOutlet var highestRankScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var rank = 2500
        var highestRank = 3000
        playerImageView.image = UIImage(named: TabBarViewController.currentUser.displayName! + "FightingLeft")
        currentRankScore.text = String(rank)
        highestRankScore.text = String(highestRank)
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
