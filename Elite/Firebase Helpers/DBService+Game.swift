//
//  DBService+Game.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct GameCollectionKeys {
    static let CollectionKey = "gamePost"
    static let GameNameKey = "gameName"
    static let GameTypeKey = "gameType"
    static let NumberOfGamersKey = "numberOfGamers"
    static let TeamA = "teamA"
    static let TeamB = "teamB"
    static let ParkId = "parkId"
    static let GameDescriptionKey = "gameDescription"
    static let GameEndTimeKey = "gameEndTime"
    static let WinnersKey = "winners"
    static let LosersKey = "losers"
    static let IsTieKey = "isTie"
    static let FormattedAdresssKey = "formattedAdresss"
    static let ParkNameKey = "parkName"
    static let LatKey = "lat"
    static let LonKey = "lon"
    static let GameIDKey = "gameID"
    static let UserID = "userID"
    static let WitnessKey = "witness"
    static let TeamAScore = "teamAScore"
    static let TeamBScore = "teamBScore"
    static let DurationKey = "duration"
}

extension DBService {
    static public func postGame(gamePost: GameModel, completion: @escaping (Error?) -> Void)  {
        firestoreDB.collection(GameCollectionKeys.CollectionKey)
            .document(gamePost.gameID).setData([
                GameCollectionKeys.GameNameKey : gamePost.gameName,
                GameCollectionKeys.GameTypeKey : gamePost.gameType,
                GameCollectionKeys.NumberOfGamersKey : gamePost.numberOfGamers,
                GameCollectionKeys.TeamA : gamePost.teamA,
                GameCollectionKeys.TeamB : gamePost.teamB,
                GameCollectionKeys.GameDescriptionKey : gamePost.gameDescription,
                GameCollectionKeys.GameEndTimeKey : gamePost.gameEndTime,
                GameCollectionKeys.WinnersKey : gamePost.winners,
                GameCollectionKeys.LosersKey : gamePost.losers,
                GameCollectionKeys.IsTieKey : gamePost.isTie,
                GameCollectionKeys.FormattedAdresssKey : gamePost.formattedAdresss,
                GameCollectionKeys.ParkNameKey : gamePost.parkName,
                GameCollectionKeys.LatKey : gamePost.lat,
                GameCollectionKeys.LonKey : gamePost.lon,
                GameCollectionKeys.GameIDKey : gamePost.gameID,
                GameCollectionKeys.UserID : gamePost.userID,
                GameCollectionKeys.WitnessKey : gamePost.witness ?? "",
                GameCollectionKeys.TeamAScore : gamePost.teamAScore,
                GameCollectionKeys.TeamBScore : gamePost.teamBScore,
                GameCollectionKeys.DurationKey : gamePost.duration])
            { (error) in
                if let error = error {
                    print("game post error: \(error)")
                    completion(error)
                } else {
                    print("game posted successfully to ref: \(gamePost.gameID)")
                    completion(nil)
                }
        }
    }
    
    
    static public func deleteGamePost(gamePost: GameModel, completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB
            .collection(GameCollectionKeys.CollectionKey)
            .document(String(gamePost.gameID))
            .delete { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
}

