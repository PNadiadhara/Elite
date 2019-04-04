//
//  GamerModel.swift
//  Elite
//
//  Created by Manny Yusuf on 4/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class GamerModel {
    let profileImage: String?
    let firstname: String
    let lastname: String
    let username: String
    let email: String
    let status: String
    let bio: String
    let qrCode: String
    let joinedDate: Int
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
    status: String,
    bio: String,
    qrCode: String,
    joinedDate: Int,
    gamerID: String) {
        self.profileImage = profileImage
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.email = email
        self.status = status
        self.bio = bio
        self.qrCode = qrCode
        self.joinedDate = joinedDate
        self.gamerID = gamerID
    }
}
