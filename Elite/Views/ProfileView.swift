//
//  ProfileView.swift
//  Elite
//
//  Created by Manny Yusuf on 4/9/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class ProfileView: UIView {

 
    @IBOutlet weak var gamePostView: RoundedView!
    @IBOutlet weak var achievementsView: RoundedView!
    @IBOutlet weak var friendListView: RoundedView!
    @IBOutlet weak var profileTableView: UITableView!
   
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
    
        required init?(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder)
                commonInit()
            }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ProfileView", owner: self, options: nil)
        
        let gamePostTap = UITapGestureRecognizer(target: self, action: #selector(gamePostHandleTap))
        gamePostView.addGestureRecognizer(gamePostTap)
        self.addSubview(gamePostView)
        
        let achievementTap = UITapGestureRecognizer(target: self, action: #selector(achievementsHandleTap))
        achievementsView.addGestureRecognizer(achievementTap)
        self.addSubview(achievementsView)
        
        let friendListTap = UITapGestureRecognizer(target: self, action: #selector(friendListHandleTap))
        friendListView.addGestureRecognizer(friendListTap)
        self.addSubview(friendListView)
    }
    
    @objc func gamePostHandleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
    }
    
    @objc func achievementsHandleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
    }
    
    @objc func friendListHandleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
    }
}
