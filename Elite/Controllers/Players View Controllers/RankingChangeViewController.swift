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
    @IBOutlet var rankGifImageView: UIImageView!
    @IBOutlet weak var parkSelectedLabel: UILabel!

    var rank = 3999

    override func viewDidLoad() {
        super.viewDidLoad()
        var highestRank = Int.random(in: 4250...4300)
        playerImageView.image = UIImage(named: GamerModel.currentGamer.username!)
        currentRankScore.text = String(rank)
        highestRankScore.text = String(highestRank)
        updateRank()
        playerUserName.text = GamerModel.currentGamer.username
        parkSelectedLabel.text = MapViewController.parkSelected
        // Do any additional setup after loading the view.
    }

    func updateRank() {
        
        rank += Int.random(in: 20...40)
        currentRankScore.pushTransition(1.5)
        currentRankScore.text = String(rank)
        rankGifImageView.loadGif(name: "EliteRank")
    }

    @IBAction func doneButton(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
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
