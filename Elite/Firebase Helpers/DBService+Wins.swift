//
//  DBService+Wins.swift
//  Elite
//
//  Created by Manny Yusuf on 4/8/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct WinsCollectionKeys {
    static let CollectionKey = "game"
    static let GameNameKey = "gameName"
    static let GamerKey = "gamer"
    static let LocationKey = "location"
    static let ScoreCountKey = "scoreCount"
}

extension DBService {
    static public func winCount(wins: WinsModel, completion: @escaping (Error?) -> Void) {
        firestoreDB.collection(WinsCollectionKeys.CollectionKey)
            .document(wins.gamer)
            .setData([ WinsCollectionKeys.GameNameKey : wins.gameName,
                       WinsCollectionKeys.GamerKey : wins.gamer,
                       WinsCollectionKeys.LocationKey : wins.location,
                       WinsCollectionKeys.ScoreCountKey : wins.scoreCount
            ]) { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
    
    static public func fetchWins(gamerId: String, completion: @escaping (Error?, WinsModel?) -> Void) {
        DBService.firestoreDB
            .collection(WinsCollectionKeys.CollectionKey)
            .whereField(WinsCollectionKeys.GamerKey, isEqualTo: gamerId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(error, nil)
                } else if let snapshot = snapshot?.documents.first {
                    let gameCreator = WinsModel(dict: snapshot.data())
                    completion(nil, gameCreator)
                }
        }
    }
}
