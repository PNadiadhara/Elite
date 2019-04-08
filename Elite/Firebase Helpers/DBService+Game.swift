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
    static let UsersKey = "users"
    static let EliteStatusKey = "eliteStatus"
    static let GameDescriptionKey = "gameDescription"
    static let GameEndTimeKey = "gameEndTime"
    static let WinnerKey = "winner"
    static let LoserKey = "loser"
    static let IsTieKey = "isTie"
    static let LocationKey = "location"
    static let GameIDKey = "gameID"
    static let PointsKey = "points"
    static let WitnessKey = "witness"
    static let ScoreCountKey = "scoreCount"
    static let DurationKey = "duration"
}

extension DBService {
    static public func postGame(gamePost: GameModel, completion: @escaping (Error?) -> Void)  {
        firestoreDB.collection(GameCollectionKeys.CollectionKey)
            .document(String(gamePost.gameID)).setData([
                GameCollectionKeys.GameNameKey : gamePost.gameName,
                GameCollectionKeys.GameTypeKey : gamePost.gameType,
                GameCollectionKeys.NumberOfGamersKey : gamePost.numberOfGamers,
                GameCollectionKeys.UsersKey : gamePost.users,
                GameCollectionKeys.EliteStatusKey : gamePost.eliteStatus,
                GameCollectionKeys.GameDescriptionKey : gamePost.gameDescription,
                GameCollectionKeys.GameEndTimeKey : gamePost.gameEndTime,
                GameCollectionKeys.WinnerKey : gamePost.winner,
                GameCollectionKeys.LoserKey : gamePost.loser,
                GameCollectionKeys.IsTieKey : gamePost.isTie,
                GameCollectionKeys.LocationKey : gamePost.location,
                GameCollectionKeys.GameIDKey : gamePost.gameID,
                GameCollectionKeys.PointsKey : gamePost.points,
                GameCollectionKeys.WitnessKey : gamePost.witness,
                GameCollectionKeys.ScoreCountKey : gamePost.scoreCount,
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

