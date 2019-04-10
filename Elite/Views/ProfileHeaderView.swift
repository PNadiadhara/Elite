//
//  ProfileHeaderView.swift
//  Elite
//
//  Created by Manny Yusuf on 4/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func willSignOutCurrentUser(_ profileHeaderView: ProfileHeaderView)
    func willEditUsersProfile(_ profileHeaderView: ProfileHeaderView)
    func willDeleteAccount(_ profileHeaderView: ProfileHeaderView)
    func willRequestMatch(_ profileHeaderView: ProfileHeaderView)
    func willAddFriends(_ profileHeaderView: ProfileHeaderView)
}

class ProfileHeaderView: UIView {
    
    @IBOutlet weak var profileImage: CircularButton!
    @IBOutlet weak var status: CircularImageView!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var requestMatch: UIButton!
    @IBOutlet weak var addFriend: UIButton!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var bio: UITextView!
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    @IBAction func profileImageButtonPressed(_ sender: CircularButton) {
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        delegate?.willEditUsersProfile(self)
    }
    
    
    @IBAction func requestMatchButtonPressed(_ sender: UIButton) {
        delegate?.willRequestMatch(self)
    }
   
    
    @IBAction func addFriendButtonPressed(_ sender: UIButton) {
        delegate?.willAddFriends(self)
    }
    
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        delegate?.willSignOutCurrentUser(self)
        delegate?.willDeleteAccount(self)
    }
}

