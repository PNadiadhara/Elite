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

//import UIKit
//
//// MARK: - Protocols
//
//class ProfileHeaderView: UIView {
//    // MARK: - Outlets & Properties
//    @IBOutlet var contentView: UIView!
//    @IBOutlet weak var coverImageView: UIImageView!
//    @IBOutlet weak var coverImageBttn: UIButton!
//    @IBOutlet weak var profileImageView: CircularImageView!
//    @IBOutlet weak var profileImageBttn: CircularButtonDesign!
//    @IBOutlet weak var editBioBttn: UIButton!
//    @IBOutlet weak var signOutBttn: UIButton!
//    @IBOutlet weak var firstName: UILabel!
//    @IBOutlet weak var lastName: UILabel!
//    @IBOutlet weak var username: UILabel!
//    @IBOutlet weak var userBio: UITextView!
//    weak var delegate: ProfileHeaderViewDelegate?
//
//    // MARK: - Initalizers
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//    // MARK: - Methods
//    private func commonInit(){
//        Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil) //
//        addSubview(contentView)
//        contentView.frame = bounds
//        coverImageView.layer.borderWidth = 4
//        coverImageView.layer.borderColor = UIColor.white.cgColor
//        coverImageView.layer.cornerRadius = 5
//        profileImageView.layer.borderWidth = 6
//        profileImageView.layer.borderColor = UIColor.white.cgColor
//        editBioBttn.layer.cornerRadius = 5
//        signOutBttn.layer.cornerRadius = 5
//        userBio.isEditable = false
//        userBio.isSelectable = false
//
//    }
//    // MARK: - Actions
//    @IBAction func editBioPressed(_ sender: Any) {
//        delegate?.willEditUsersProfile(self)
//    }
//    @IBAction func signOutPressed(_ sender: Any) {
//        delegate?.willSignOutCurrentUser(self)
//    }
//
//}
