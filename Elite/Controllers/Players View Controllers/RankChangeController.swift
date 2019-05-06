 //
//  RankChangeController.swift
//  Elite
//
//  Created by Pritesh Nadiadhara on 5/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class RankChangeController: UIViewController {
var rank = 2700
    @IBOutlet var playerImageView: CircularRedImageView!
    @IBOutlet var playerUserName: UILabel!
    @IBOutlet var currentRankScore: UILabel!
    @IBOutlet var highestRankScore: UILabel!
    
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

}

extension UIView {
    func pushTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
    func pullTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromBottom
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
}
