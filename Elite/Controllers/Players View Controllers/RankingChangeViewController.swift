//
//  RankingChangeViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 5/6/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class RankingChangeViewController: UIViewController {
    @IBOutlet var playerImageView: CircularRedImageView!
    @IBOutlet var playerUserName: UILabel!
    @IBOutlet var currentRankScore: UILabel!
    @IBOutlet var highestRankScore: UILabel!
var rank = 2700
    override func viewDidLoad() {
        super.viewDidLoad()
        var highestRank = 3000
        playerImageView.image = UIImage(named: TabBarViewController.currentUser.displayName! + "FightingLeft")
        currentRankScore.text = String(rank)
        highestRankScore.text = String(highestRank)
        updateRank()
        // Do any additional setup after loading the view.
    }

    func updateRank() {
        
        rank += Int.random(in: 20...40)
        currentRankScore.pushTransition(1.5)
        currentRankScore.text = String(rank)
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
