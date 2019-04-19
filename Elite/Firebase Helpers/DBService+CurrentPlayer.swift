//
//  DBService+CurrentPlayer.swift
//  Elite
//
//  Created by Leandro Wauters on 4/18/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

extension DBService {
    static func postCurrentPlayer(currentPlayer: CurrentPlayer, completion: @escaping (Error?) -> Void) {
            let ref = firestoreDB.collection(CurrentPlayersCollectionKeys.collectionKey).document()
        DBService.firestoreDB.collection(CurrentPlayersCollectionKeys.collectionKey).document(ref.documentID).setData([CurrentPlayersCollectionKeys.gamerIdKey : currentPlayer.gamerId, CurrentPlayersCollectionKeys.teamRoleKey : currentPlayer.teamRole]) { (error) in
            if let error = error {
                completion(error)
            }
        }
    }
    static func fetchCurrentGamerTeamRole(gamerId: String, completion: @escaping (Error?, String?) -> Void) {
        firestoreDB.collection(CurrentPlayersCollectionKeys.collectionKey).whereField(CurrentPlayersCollectionKeys.gamerIdKey, isEqualTo: gamerId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(error,nil)
            }
            var gamer = [CurrentPlayer]()
            if let snapshot = snapshot {
               
                gamer = snapshot.documents.map {CurrentPlayer.init(dict: $0.data())}
                completion(nil, gamer.first?.teamRole)
            }
        }
    }
}
