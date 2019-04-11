//
//  GameModel.swift
//  Elite
//
//  Created by Manny Yusuf on 4/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

/*
 // TODO: documentation
*/

import Foundation

class GameModel {
    let gameName: String // TODO: enum
    let gameType: String // TODO: enum
    let numberOfGamers: Int
    let teamA: [String] // ids
    let teamB: [String]
    let parkId: String
    let gameDescription: String
    let gameEndTime: String
    let winners: [String]
    let losers: [String]
    let isTie: Bool
    let formattedAdresss: String
    let parkName: String
    let lat: Double
    let lon: Double
    let gameID: String
    let userID: String
    let witness: String?
    let teamAScore: Int
    let teamBScore: Int
    let duration: Double
    
    
    
    init(gameName: String,
    gameType: String,
    numberOfPlayers: Int,
    teamA: [String],
    teamB: [String],
    parkId: String,
    gameDescription: String,
    gameEndTime: String,
    winners: [String],
    losers: [String],
    isTie: Bool,
    formattedAdresss: String,
    parkName: String,
    lat: Double,
    lon: Double,
    gameID: String,
    userID: String,
    witness: String,
    teamAScore: Int,
    teamBScore: Int,
    duration: Double) {
        self.gameName = gameName
        self.gameType = gameType
        self.numberOfGamers = numberOfPlayers
        self.teamA = teamA
        self.teamB = teamB
        self.parkId = parkId
        self.gameDescription = gameDescription
        self.gameEndTime = gameEndTime
        self.winners = winners
        self.losers = losers
        self.isTie = isTie
        self.formattedAdresss = formattedAdresss
        self.parkName = parkName
        self.lat = lat
        self.lon = lon
        self.gameID = gameID
        self.userID = userID
        self.witness = witness
        self.teamAScore = teamAScore
        self.teamBScore = teamBScore
        self.duration = duration
    }
    
    init(dict: [String: Any]) {
        self.gameName = dict[GameCollectionKeys.GameNameKey] as? String ?? ""
        self.gameType = dict[GameCollectionKeys.GameTypeKey] as? String ?? ""
        self.numberOfGamers = dict[GameCollectionKeys.NumberOfGamersKey] as? Int ?? 0
        self.teamA = dict[GameCollectionKeys.TeamA] as? [String] ?? ["",""]
        self.teamB = dict[GameCollectionKeys.TeamB] as? [String] ?? ["",""]
        self.parkId = dict[GameCollectionKeys.ParkId] as? String ?? ""
        self.gameDescription = dict[GameCollectionKeys.GameDescriptionKey] as? String ?? ""
        self.gameEndTime =  dict[GameCollectionKeys.GameEndTimeKey] as? String ?? ""
        self.winners = dict[GameCollectionKeys.WinnersKey] as? [String] ?? ["",""]
        self.losers = dict[GameCollectionKeys.LosersKey] as?  [String] ?? ["",""]
        self.isTie = dict[GameCollectionKeys.IsTieKey] as? Bool ?? true
        self.formattedAdresss = dict[GameCollectionKeys.FormattedAdresssKey] as? String ?? ""
        self.parkName = dict[GameCollectionKeys.ParkNameKey] as? String ?? ""
        self.lat = dict[GameCollectionKeys.LatKey] as? Double ?? 0
        self.lon = dict[GameCollectionKeys.LonKey] as? Double ?? 0
        self.gameID = dict[GameCollectionKeys.GameIDKey] as? String ?? ""
        self.userID = dict[GameCollectionKeys.UserID] as? String ?? ""
        self.witness = dict[GameCollectionKeys.WitnessKey] as? String ?? ""
        self.teamAScore = dict[GameCollectionKeys.TeamAScore] as? Int ?? 0
        self.teamBScore = dict[GameCollectionKeys.TeamBScore] as? Int ?? 0
        self.duration = dict[GameCollectionKeys.DurationKey] as? Double ?? 0
    }
//    let gameName: String
//    let gameType: String
//    let numberOfGamers: Int
//    let teamA: [String]
//    let teamB: [String]
//    let parkId: String
//    let gameDescription: String
//    let gameEndTime: String
//    let winners: [String]
//    let losers: String
//    let isTie: Bool
//    let location: String
//    let gameID: String
//    let userID: String
//    let witness: String
//    let teamAScore: Int
//    let teamBScore: Int
//    let duration: Double
}
