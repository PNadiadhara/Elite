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
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        gamePostView.addGestureRecognizer(tap)
        gamePostView.isUserInteractionEnabled = true
        self.addSubview(gamePostView)
        
        achievementsView.addGestureRecognizer(tap)
        achievementsView.isUserInteractionEnabled = true
        self.addSubview(achievementsView)
        
        friendListView.addGestureRecognizer(tap)
        friendListView.isUserInteractionEnabled = true
        self.addSubview(friendListView)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
    }
}
