//
//  GameModel.swift
//  Elite
//
//  Created by Manny Yusuf on 4/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class GameModel {
    let gameName: String
    let gameType: String
    let numberOfGamers: Int
    let users: String
    let eliteStatus: String
    let gameDescription: String
    let gameEndTime: Double
    let winner: String
    let loser: String
    let isTie: Bool
    let location: String
    let gameID: Int
    let points: Int
    let witness: String
    let scoreCount: Int
    let duration: Double
    
    
    init(gameName: String,
    gameType: String,
    numberOfPlayers: Int,
    users: String,
    eliteStatus: String,
    gameDescription: String,
    gameEndTime: Double,
    winner: String,
    loser: String,
    isTie: Bool,
    location: String,
    gameID: Int,
    points: Int,
    witness: String,
    scoreCount: Int,
    duration: Double) {
        self.gameName = gameName
        self.gameType = gameType
        self.numberOfGamers = numberOfPlayers
        self.users = users
        self.eliteStatus = eliteStatus
        self.gameDescription = gameDescription
        self.gameEndTime = gameEndTime
        self.winner = winner
        self.loser = loser
        self.isTie = isTie
        self.location = location
        self.gameID = gameID
        self.points = points
        self.witness = witness
        self.scoreCount = scoreCount
        self.duration = duration
    }
    
    init(dict: [String: Any]) {
        self.gameName = dict[GameCollectionKeys.GameNameKey] as? String ?? ""
        self.gameType = dict[GameCollectionKeys.GameTypeKey] as? String ?? ""
        self.numberOfGamers = dict[GameCollectionKeys.NumberOfGamersKey] as? Int ?? 0
        self.users = dict[GameCollectionKeys.UsersKey] as? String ?? ""
        self.eliteStatus = dict[GameCollectionKeys.EliteStatusKey] as? String ?? ""
        self.gameDescription = dict[GameCollectionKeys.GameDescriptionKey] as? String ?? ""
        self.gameEndTime =  dict[GameCollectionKeys.GameEndTimeKey] as? Double ?? 0
        self.winner = dict[GameCollectionKeys.WinnerKey] as? String ?? ""
        self.loser = dict[GameCollectionKeys.LoserKey] as? String ?? ""
        self.isTie = dict[GameCollectionKeys.IsTieKey] as? Bool ?? true
        self.location = dict[GameCollectionKeys.LocationKey] as? String ?? ""
        self.gameID = dict[GameCollectionKeys.GameIDKey] as? Int ?? 0
        self.points = dict[GameCollectionKeys.PointsKey] as? Int ?? 0
        self.witness = dict[GameCollectionKeys.WitnessKey] as? String ?? ""
        self.scoreCount = dict[GameCollectionKeys.ScoreCountKey] as? Int ?? 0
        self.duration = dict[GameCollectionKeys.DurationKey] as? Double ?? 0
    }
}
