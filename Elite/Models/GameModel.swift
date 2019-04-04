//
//  GameModel.swift
//  Elite
//
//  Created by Manny Yusuf on 4/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class GameModel {
    let category: String
    let gameLocation: String
    let numberOfGamers: Int
    let games: String
    let user: [GamerModel]
    let gameEndTime: Double
    let duration: Double
    let gameDescription: String
    
    init(category: String,
    gameLocation: String,
    numberOfPlayers: Int,
    games: String,
    user: [GamerModel],
    gameEndTime: Double,
    duration: Double,
    gameDescription: String) {
        self.category = category
        self.gameLocation = gameLocation
        self.numberOfGamers = numberOfPlayers
        self.games = games
        self.user = user
        self.gameEndTime = gameEndTime
        self.duration = duration
        self.gameDescription = gameDescription
    }
}
