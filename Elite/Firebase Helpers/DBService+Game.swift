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
    static let isOverKey = "isOver"
}

extension DBService {
    static public func postGame(gamePost: GameModel, completion: @escaping (Error?, String?) -> Void)  {
        let ref = firestoreDB.collection(GameCollectionKeys.CollectionKey).document()
        firestoreDB.collection(GameCollectionKeys.CollectionKey)
            .document(ref.documentID).setData([
                GameCollectionKeys.GameNameKey : gamePost.gameName,
                GameCollectionKeys.GameTypeKey : gamePost.gameType,
                GameCollectionKeys.NumberOfGamersKey : gamePost.numberOfGamers,
                GameCollectionKeys.TeamA : gamePost.teamA,
                GameCollectionKeys.TeamB : gamePost.teamB,
                GameCollectionKeys.GameDescriptionKey : gamePost.gameDescription ?? "",
                GameCollectionKeys.GameEndTimeKey : gamePost.gameEndTime ?? "",
                GameCollectionKeys.WinnersKey : gamePost.winners ?? "",
                GameCollectionKeys.GameIDKey :  ref.documentID,
                GameCollectionKeys.WitnessKey : gamePost.witness ?? "",
                GameCollectionKeys.DurationKey : gamePost.duration ?? "", GameCollectionKeys.isOverKey : gamePost.isOver,GameCollectionKeys.LosersKey : gamePost.losers ?? "",
                GameCollectionKeys.IsTieKey : gamePost.isTie ?? "",
                GameCollectionKeys.FormattedAdresssKey : gamePost.formattedAdresss,
                GameCollectionKeys.ParkNameKey : gamePost.parkName,
                GameCollectionKeys.LatKey : gamePost.lat,
                GameCollectionKeys.LonKey : gamePost.lon])
            { (error) in
                if let error = error {
                    print("game post error: \(error)")
                    completion(error,nil)
                }
                completion(nil, ref.documentID)
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
    static public func fetchGame(gameId: String, completion: @escaping(Error?, GameModel?) -> Void) {
        DBService.firestoreDB.collection(GameCollectionKeys.CollectionKey).whereField(GameCollectionKeys.GameIDKey, isEqualTo: gameId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                let game = snapshot.documents.map {GameModel.init(dict: $0.data())}
                completion(nil, game.first)
            }
        }
        
    }
    static public func updateGameToFinish(gameId: String) {
    DBService.firestoreDB.collection(GameCollectionKeys.CollectionKey).document(gameId).updateData([GameCollectionKeys.isOverKey : true])
    }
    static public func updateGameModel(gameId: String,game: GameModel, completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB.collection(GameCollectionKeys.CollectionKey).document(game.gameID).updateData([GameCollectionKeys.GameDescriptionKey : game.gameDescription ?? "", GameCollectionKeys.GameEndTimeKey : game.gameEndTime ?? "N/A", GameCollectionKeys.WinnersKey : game.winners ?? "N/A", GameCollectionKeys.LosersKey : game.losers ?? "N/A", GameCollectionKeys.IsTieKey : game.isTie ?? "N/A",GameCollectionKeys.WitnessKey : game.witness ?? "N/A", GameCollectionKeys.DurationKey : game.duration ?? "N/A", GameCollectionKeys.isOverKey : false]) { (error
            ) in
            if let error = error {
               completion(error)
            }
        }
    }
//    static public func updateInvitationApprovalToTrue(invitation: Invitation,completion: @escaping (Error?) -> Void) {
//        DBService.firestoreDB.collection(InvitationCollectionKeys.collectionKey).document(invitation.invitationId).updateData([InvitationCollectionKeys.approvalKey : true ]) { (error) in
//            if let error = error {
//                completion(error)
//            }
//        }
//    }
}

