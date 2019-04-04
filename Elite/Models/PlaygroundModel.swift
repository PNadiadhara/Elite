//
//  PlaygroundModel.swift
//  Elite
//
//  Created by Manny Yusuf on 4/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class PlaygroundModel {
    let location: String
    let name: String
    let users: String
    let isAnElite: Bool
    let game: String
    let wins: Int
    let losses: Int
    let rank: Int
    let parkID: String
    
    init(location: String,
    name: String,
    users: String,
    isAnElite: Bool,
    game: String,
    wins: Int,
    losses: Int,
    rank: Int,
    parkID: String) {
        self.location = location
        self.name = name
        self.users = users
        self.isAnElite = isAnElite
        self.game = game
        self.wins = wins
        self.losses = losses
        self.rank = rank
        self.parkID = parkID
    }
}
