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

class GameModel: Codable {
    var gameName: String // TODO: enum
    var gameType: String // TODO: enum

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
    var lat: String
    var lon: String
    var gameID: String
    var witness: String?
//    let teamAScore: Int?
//    let teamBScore: Int?
    var duration: String?
    var players: [String]
    
    static var game: GameModel?
    
    static var parkId: String?
    static var gameName: String?
    static var gameTypeSelected: String?
    static var parkSelected: String?
    static var formattedAddress: String?
    static var parkLat: String?
    static var parkLon: String?
    static var gameId: String?

    

    
    static func createGame(gameName: String, gameType: String, redTeam: [String], blueTeam: [String], parkId: String, formattedAdress: String, parkName: String, lat: String, lon: String, gameId: String, players: [String]) {
        
        GameModel.game = GameModel(gameName: gameName, gameType: gameType, redTeam: redTeam, blueTeam: blueTeam, parkId: parkId, gameDescription: nil, gameEndTime: nil, winners: nil, losers: nil, isTie: nil, formattedAdresss: formattedAdress, parkName: parkName, lat: lat, lon: lon, gameID: gameId, witness: nil, duration: nil, players: players)
    }

    //TO DO CREATE A GAME MODEL AT THE END AND SEND IT TO GUEST AND THEN UPLOAD TO FIREBASE

    
    static func guestUpdateGameName(gameName: String) {
        GameModel.game?.gameName = gameName
    }
    
    static func updateGameModel(gameEndTime: String, winners: [String], losers: [String],duration: String, done: () -> Void) {
        GameModel.game!.gameEndTime = gameEndTime
        GameModel.game!.winners = winners
        GameModel.game!.losers = losers
        GameModel.game!.duration = duration
        done()
    }
    
    static func clearGameModel(gameModel: GameModel) {
        parkId = nil
        gameName = nil
        gameTypeSelected = nil
        parkSelected = nil
        formattedAddress =  nil
        parkLat = nil
        parkLon = nil
        gameId = nil
        game = nil
        
    }
    

    init(gameName: String,
    gameType: String,
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
    lat: String,
    lon: String,
    gameID: String,
    witness: String?,
    duration: String?, players: [String]) {
        self.gameName = gameName
        self.gameType = gameType
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
        self.players = players

    }

    init(dict: [String: Any]) {
        self.gameName = dict[GameCollectionKeys.GameNameKey] as? String ?? ""
        self.gameType = dict[GameCollectionKeys.GameTypeKey] as? String ?? ""
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
        self.lat = dict[GameCollectionKeys.LatKey] as? String ?? ""
        self.lon = dict[GameCollectionKeys.LonKey] as? String ?? ""
        self.gameID = dict[GameCollectionKeys.GameIDKey] as? String ?? ""
        self.witness = dict[GameCollectionKeys.WitnessKey] as? String ?? ""
        self.duration = dict[GameCollectionKeys.DurationKey] as? String ?? ""
        self.players = dict[GamerCollectionKeys.PlayersKey] as? [String] ?? ["",""]
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
