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
    var gameName: String // TODO: enum
    var gameType: String // TODO: enum
    var numberOfGamers: Int
    var redTeam: [String] // ids
    var blueTeam: [String]
    var parkId: String
    var gameDescription: String?
    var gameEndTime: String?
    var winners: [String]?
    var losers: [String]?
    var isTie: Bool?
    var formattedAdresss: String
    var parkName: String
    var lat: Double
    var lon: Double
    var gameID: String
    var witness: String?
//    let teamAScore: Int?
//    let teamBScore: Int?
    var duration: String?
    var isOver: Bool?
    var wasCancelled: Bool?
    
    static var gameCreated = GameModel(gameName: "", gameType: "", numberOfPlayers: 0, redTeam: [""], blueTeam: [""], parkId: "", gameDescription: nil, gameEndTime: nil, winners: nil, losers: nil, isTie: nil, formattedAdresss: "", parkName: "", lat: 0.0, lon: 0.0, gameID: "", witness: nil, duration: "", isOver: nil, wasCancelled: nil)
    

    init(gameName: String,
    gameType: String,
    numberOfPlayers: Int,
    redTeam: [String],
    blueTeam: [String],
    parkId: String,
    gameDescription: String?,
    gameEndTime: String?,
    winners: [String]?,
    losers: [String]?,
    isTie: Bool?,
    formattedAdresss: String,
    parkName: String,
    lat: Double,
    lon: Double,
    gameID: String,
    witness: String?,
    duration: String?,
    isOver: Bool?, wasCancelled: Bool?) {
        self.gameName = gameName
        self.gameType = gameType
        self.numberOfGamers = numberOfPlayers
        self.redTeam = redTeam
        self.blueTeam = blueTeam
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
        self.witness = witness
        self.duration = duration
        self.isOver = isOver
        self.wasCancelled = wasCancelled
    }

    init(dict: [String: Any]) {
        self.gameName = dict[GameCollectionKeys.GameNameKey] as? String ?? ""
        self.gameType = dict[GameCollectionKeys.GameTypeKey] as? String ?? ""
        self.numberOfGamers = dict[GameCollectionKeys.NumberOfGamersKey] as? Int ?? 0
        self.redTeam = dict[GameCollectionKeys.TeamA] as? [String] ?? ["",""]
        self.blueTeam = dict[GameCollectionKeys.TeamB] as? [String] ?? ["",""]
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
        self.witness = dict[GameCollectionKeys.WitnessKey] as? String ?? ""
        self.duration = dict[GameCollectionKeys.DurationKey] as? String ?? ""
        self.isOver = dict[GameCollectionKeys.isOverKey] as? Bool ?? false
        self.wasCancelled = dict[GameCollectionKeys.wasCancelledKey] as? Bool ?? false
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
