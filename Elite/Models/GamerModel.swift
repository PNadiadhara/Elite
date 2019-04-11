//
//  GamerModel.swift
//  Elite
//
//  Created by Manny Yusuf on 4/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class GamerModel {
    let profileImage: String? //(Bitmoji image)
    let firstname: String
    let lastname: String
    let username: String
    let email: String
    let status: String? //(rank i.e. Bronze, Gold< Diamond)
    let achievements: [String]?
    let bio: String?
    let qrCode: String
    let joinedDate: String
    let gamerID: String
    
    public var fullname: String {
        return ((firstname ?? "") + " " + (lastname ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(profileImage: String?,
    fullname: String,
    firstname: String,
    lastname: String,
    username: String,
    email: String,
    status: String?,
    achievements: [String]?,
    bio: String?,
    qrCode: String,
    joinedDate: String,
    gamerID: String) {
        self.profileImage = profileImage
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.email = email
        self.status = status
        self.achievements = achievements
        self.bio = bio
        self.qrCode = qrCode
        self.joinedDate = joinedDate
        self.gamerID = gamerID
    }
    
    init(dict: [String: Any]) {
        self.profileImage = dict[GamerCollectionKeys.ProfileImageURLKey] as? String ?? ""
        self.firstname = dict[GamerCollectionKeys.FirstNameKey] as? String ?? ""
        self.lastname = dict[GamerCollectionKeys.LastNameKey] as? String ?? ""
        self.username = dict[GamerCollectionKeys.UserNameKey] as? String ?? ""
        self.email = dict[GamerCollectionKeys.EmailKey] as? String ?? ""
        self.status = dict[GamerCollectionKeys.StatusKey] as? String ?? ""
        self.achievements = dict[GamerCollectionKeys.AchievementsKey] as? [String] ?? ["",""]
        self.bio = dict[GamerCollectionKeys.BioKey] as? String ?? "FirstName"
        self.qrCode = dict[GamerCollectionKeys.QRcodeKey] as? String ?? "LastName"
        self.joinedDate = dict[GamerCollectionKeys.JoinedDateKey] as? String ?? ""
        self.gamerID = dict[GamerCollectionKeys.GamerIDKey] as? String ?? ""
    }
}
