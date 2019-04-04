//
//  TournamentModel.swift
//  Elite
//
//  Created by Manny Yusuf on 4/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class TournamentModel {
    let numberOfGamers: Int
    let category: String
    let games: String
    let timeDuration: Int
    let gamelocation: String
    
    init(numberOfGamers: Int,
    category: String,
    games: String,
    timeDuration: Int,
    gamelocation: String) {
        self.numberOfGamers = numberOfGamers
        self.category = category
        self.games = games
        self.timeDuration = timeDuration
        self.gamelocation = gamelocation
    }
}
