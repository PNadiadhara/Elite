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

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

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
    static let PlayersKey = "players"
//    static let isOverKey = "isOver"
//    static let wasCancelledKey = "wasCancelled"
}

extension DBService {
    static public func postGame(gamePost: GameModel, completion: @escaping (Error?) -> Void)  {
        let na = "N/A"
        let ref = firestoreDB.collection(GameCollectionKeys.CollectionKey).document()
        firestoreDB.collection(GameCollectionKeys.CollectionKey)
            .document(ref.documentID).setData([
                GameCollectionKeys.GameNameKey : gamePost.gameName,
                GameCollectionKeys.GameTypeKey : gamePost.gameType,
                GameCollectionKeys.TeamA : gamePost.redTeam,
                GameCollectionKeys.TeamB : gamePost.blueTeam,
                GameCollectionKeys.GameDescriptionKey : gamePost.gameDescription ?? na,
                GameCollectionKeys.GameEndTimeKey : gamePost.gameEndTime ?? na,
                GameCollectionKeys.WinnersKey : gamePost.winners ?? [na],
                GameCollectionKeys.GameIDKey :  ref.documentID,
                GameCollectionKeys.WitnessKey : gamePost.witness ?? na,
                GameCollectionKeys.DurationKey : gamePost.duration ?? na,  GameCollectionKeys.LosersKey : gamePost.losers ?? [na],
                GameCollectionKeys.IsTieKey : gamePost.isTie ?? false,
                GameCollectionKeys.FormattedAdresssKey : gamePost.formattedAdresss,
                GameCollectionKeys.ParkNameKey : gamePost.parkName,
                GameCollectionKeys.LatKey : gamePost.lat,
                GameCollectionKeys.LonKey : gamePost.lon,
                GameCollectionKeys.PlayersKey : gamePost.players,
                GameCollectionKeys.ParkId : gamePost.parkId
                ])
            { (error) in
                if let error = error {
                    completion(error)
                } else {
                    print("blog posted successfully to ref: \(ref.documentID)")
                    completion(nil)
                }
        }
    }
    
    
    static public func deleteGamePost(gameId: String, completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB
            .collection(GameCollectionKeys.CollectionKey)
            .document(gameId)
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

    static public func fetchPlayersGamesPlayed(gamerId: String, completion: @escaping (Error? , [GameModel]?) -> Void) {
        let query = firestoreDB.collection(GameCollectionKeys.CollectionKey)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(error, nil)
            }
            if let snapshot = snapshot {
                var games = [GameModel]()
                for document in snapshot.documents {
                    let allGames = GameModel.init(dict: document.data())
                    games.append(allGames)
                }
                completion(nil, games.filter({ (game) -> Bool in
                    (game.winners?.contains(gamerId))! || game.losers!.contains(gamerId)
                }))
            }
        }
        

    }
    static public func fetchGamesWherePlayersPlayedEachOther(gamersId: String, completion: @escaping (Error? , [GameModel]?) -> Void) {
        let players = [TabBarViewController.currentUser.uid, gamersId]
        let query = firestoreDB.collection(GameCollectionKeys.CollectionKey)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(error, nil)
            }
            if let snapshot = snapshot {
                var games = [GameModel]()
                for document in snapshot.documents {
                    let allGames = GameModel.init(dict: document.data())
                    games.append(allGames)
                }
                completion(nil, games.filter({ (game) -> Bool in
                    game.players.containsSameElements(as: players)
                }))
            }
        }
    }
    static public func fetchPlayersGamePlayedAtPark(parkId: String, gamerId: String, completion: @escaping(Error?, [GameModel]) -> Void) {
        fetchPlayersGamesPlayed(gamerId: gamerId) { (error, games) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let games = games {
                let gamesWithUserId = games.filter {$0.parkId == parkId}
                completion(nil, gamesWithUserId)
            }
        }
    }
    
    static public func findPlayersWinsAtPark(parkId: String, gamerId: String, complete: @escaping(Int) -> Void) {
        
        fetchPlayersGamePlayedAtPark(parkId: parkId, gamerId: gamerId) { (error, games) in
            if let error = error {
                print(error.localizedDescription)
            }
            let gamesWon = games.filter{($0.winners?.contains(gamerId))!}.count
            complete(gamesWon)
        }
        
    }
    
    static public func findPlayersLossesAtPark(parkId: String, gamerId: String,complete: @escaping(Int) -> Void)  {
        fetchPlayersGamePlayedAtPark(parkId: parkId, gamerId: gamerId) { (error, games) in
            if let error = error {
                print(error.localizedDescription)
            }
            let gamesLost = games.filter{($0.losers?.contains(gamerId))!}.count
            complete(gamesLost)
        }
    }
    
    static public func getPlayerWinsByPark(parkId: String?, completion: @escaping (Error?, Int?) -> Void) {
        
    }


    
//    static public func updateInvitationApprovalToTrue(invitation: Invitation,completion: @escaping (Error?) -> Void) {
//        DBService.firestoreDB.collection(InvitationCollectionKeys.collectionKey).document(invitation.invitationId).updateData([InvitationCollectionKeys.approvalKey : true ]) { (error) in
//            if let error = error {
//                completion(error)
//            }
//        }
//    }
}

