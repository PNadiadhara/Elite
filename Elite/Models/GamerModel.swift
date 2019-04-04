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
    let wins: Int
    let losses: Int
    let rank: String
    let status: String
    let statusLocation: String
    let eliteStatus: String
    let eliteStatusLocation: String
    let bio: String
    let qrCode: String
    let date: Int
    let game: [GameModel]
    let gamerID: String
    
    public var fullname: String {
        return ((firstname ?? "") + " " + (lastname ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(profileImage: String?,
    fullname: String,
    firstname: String,
    lastname: String,
    username: String,
    wins: Int,
    losses: Int,
    rank: String,
    status: String,
    statusLocation: String,
    eliteStatus: String,
    eliteStatusLocation: String,
    bio: String,
    qrCode: String,
    date: Int,
    game: [GameModel],
    gamerID: String) {
        self.profileImage = profileImage
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.wins = wins
        self.losses = losses
        self.rank = rank
        self.status = status
        self.statusLocation = statusLocation
        self.eliteStatus = eliteStatus
        self.eliteStatusLocation = eliteStatusLocation
        self.bio = bio
        self.qrCode = qrCode
        self.date = date
        self.game = game
        self.gamerID = gamerID
    }
}
