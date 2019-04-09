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
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    
    gamePostView.addGestureRecognizer(tap)
    
    gamePostView.userInteractionEnabled = true
    
    self.view.addSubview(gamePostView)
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
    }

}
