//
//  DBService+Playground.swift
//  Elite
//
//  Created by Manny Yusuf on 4/8/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct PlaygroundCollectionKeys {
    static let CollectionKey = "gamer"
    static let LocationKey = "location"
    static let NameKey = "name"
    static let UsersKey = "users"
    static let IsAnEliteKey = "isAnElite"
    static let GameKey = "game"
    static let WinsKey = "wins"
    static let LossesKey = "losses"
    static let RankKey = "rank"
    static let ParkIDKey = "parkID"
    static let JsonParkID = "jsonParkId"
}

extension DBService {
    static public func addPlayground(playground: PlaygroundModel, completion: @escaping (Error?) -> Void) {
        firestoreDB.collection(PlaygroundCollectionKeys.CollectionKey)
            .document(playground.users)
            .setData([ PlaygroundCollectionKeys.LocationKey : playground.location,
                       PlaygroundCollectionKeys.NameKey : playground.name,
                       PlaygroundCollectionKeys.UsersKey : playground.users,
                       PlaygroundCollectionKeys.IsAnEliteKey : playground.isAnElite ,
                       PlaygroundCollectionKeys.GameKey : playground.game,
                       PlaygroundCollectionKeys.WinsKey : playground.wins ,
                       PlaygroundCollectionKeys.LossesKey : playground.losses,
                       PlaygroundCollectionKeys.RankKey : playground.rank,
                       PlaygroundCollectionKeys.ParkIDKey : playground.parkID
            ]) { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
            }
        }
    }
    
    
    static public func fetchLocation(gamerId: String, completion: @escaping (Error?, PlaygroundModel?) -> Void) {
        DBService.firestoreDB
            .collection(PlaygroundCollectionKeys.CollectionKey)
            .whereField(PlaygroundCollectionKeys.UsersKey, isEqualTo: gamerId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(error, nil)
                } else if let snapshot = snapshot?.documents.first {
                    let gameCreator = PlaygroundModel(dict: snapshot.data())
                    completion(nil, gameCreator)
                }
        }
    }
    
}
