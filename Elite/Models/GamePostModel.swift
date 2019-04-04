//
//  GamePostModel.swift
//  Elite
//
//  Created by Manny Yusuf on 4/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class GamePostModel {
    let category: String
    let gamelocation: String
    let gamer: String
    let gametype: String
    let gameduration: Double
    let witness: String
    
    init(category: String,
    gamelocation: String,
    gamer: String,
    gametype: String,
    gameduration: Double,
    witness: String) {
        self.category = category
        self.gamelocation = gamelocation
        self.gamer = gamer
        self.gametype = gametype
        self.gameduration = gameduration
        self.witness = witness
    }
}
