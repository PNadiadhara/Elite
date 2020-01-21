//
//  DBService+User.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct GamerCollectionKeys {
    static let CollectionKey = "gamer"
    static let ProfileImageURLKey = "profileImage"
    static let FirstNameKey = "firstName"
    static let LastNameKey = "lastName"
    static let UserNameKey = "userName"
    static let EmailKey = "email"
    static let StatusKey = "status"
    static let AchievementsKey = "achievements"
    static let BioKey = "bio"
    static let QRcodeKey = "qrCode"
    static let JoinedDateKey = "joinedDate"
    static let GamerIDKey = "gamerID"
    static let MyParks = "myParks"
    static let NumberOfHandballGamesPlayed = "numberOfHandballGamesPlayed"
    static let NumberOfBasketballGamesPlayer = "numberOfBasketballGamesPlayed"
    static let FriendsKey = "friends"
    static let RoleKey = "role"
    static let deviceName = "deviceName"
    static let PlayersKey = "players"
    static let HandBallGamesWinsByLocation = "handBallGamesWinsByLocation"
    static let BasketBallWinsPlayedByLocation = "basketBallGamesWinsByLocation"
}
extension DBService {
    static public func createUser(gamer: GamerModel, completion: @escaping (Error?) -> Void) {
        firestoreDB.collection(GamerCollectionKeys.CollectionKey)
            .document(gamer.gamerID)
            .setData([ GamerCollectionKeys.ProfileImageURLKey : gamer.profileImage ?? "",
                       GamerCollectionKeys.FirstNameKey : gamer.firstname,
                       GamerCollectionKeys.LastNameKey : gamer.lastname,
                       GamerCollectionKeys.UserNameKey : gamer.username ?? "",
                       GamerCollectionKeys.EmailKey : gamer.email,
                       GamerCollectionKeys.StatusKey : gamer.status ?? "",
                       GamerCollectionKeys.AchievementsKey : gamer.achievements ?? "",
                       GamerCollectionKeys.BioKey : gamer.bio ?? "",
                       GamerCollectionKeys.QRcodeKey : gamer.qrCode,
                       GamerCollectionKeys.JoinedDateKey  : gamer.joinedDate,
                       GamerCollectionKeys.GamerIDKey : gamer.gamerID,
                       GamerCollectionKeys.FriendsKey : gamer.friends ?? "",
                       GamerCollectionKeys.HandBallGamesWinsByLocation : gamer.handBallWinsPlayedByLocation ?? "", GamerCollectionKeys.BasketBallWinsPlayedByLocation : gamer.basketBallGamesWinsByLocation ?? ""
            ]) { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
    static public func updateUserProfileImage(userId: String, imageUrl: String) {
        DBService.firestoreDB
            .collection(GamerCollectionKeys.CollectionKey).document(userId).updateData([GamerCollectionKeys.ProfileImageURLKey : imageUrl]) { (error) in
                if let error = error{
                    print("Error updating profile: \(error.localizedDescription)")
                }
        }
    }
    
    static public func updateWinsByLocation(parkId: String, sport: String) {
        if sport  == SportType.handball.rawValue {
        guard var winsByLocation = GamerModel.currentGamer.handBallWinsPlayedByLocation else {
            GamerModel.currentGamer.handBallWinsPlayedByLocation = [parkId : 1]
            print("Dict is nil")
            DBService.firestoreDB .collection(GamerCollectionKeys.CollectionKey).document(GamerModel.currentGamer.gamerID).updateData([GamerCollectionKeys.HandBallGamesWinsByLocation : GamerModel.currentGamer.handBallWinsPlayedByLocation!]) { (error) in
                if let error = error {
                    print(error)
                }
            }
            return
        }
        if let parkWins = winsByLocation[parkId] {
            winsByLocation[parkId] = parkWins + 1
        } else {
            winsByLocation[parkId] = 1
        }
            DBService.firestoreDB .collection(GamerCollectionKeys.CollectionKey).document(GamerModel.currentGamer.gamerID).updateData([GamerCollectionKeys.HandBallGamesWinsByLocation : winsByLocation]) { (error) in
                if let error = error {
                    print(error)
                }
        }
        } else {
            guard var winsByLocation = GamerModel.currentGamer.basketBallGamesWinsByLocation else {
                GamerModel.currentGamer.basketBallGamesWinsByLocation = [parkId : 1]
                print("Dict is nil")
                DBService.firestoreDB .collection(GamerCollectionKeys.CollectionKey).document(GamerModel.currentGamer.gamerID).updateData([GamerCollectionKeys.BasketBallWinsPlayedByLocation : GamerModel.currentGamer.basketBallGamesWinsByLocation!]) { (error) in
                    if let error = error {
                        print(error)
                    }
                }
                return
            }
            if let parkWins = winsByLocation[parkId] {
                winsByLocation[parkId] = parkWins + 1
            } else {
                winsByLocation[parkId] = 1
            }
            DBService.firestoreDB .collection(GamerCollectionKeys.CollectionKey).document(GamerModel.currentGamer.gamerID).updateData([GamerCollectionKeys.BasketBallWinsPlayedByLocation : winsByLocation]) { (error) in
                    if let error = error {
                        print(error)
                    }
            }
        }
        
    }
    static public func fetchGamer(gamerID: String, completion: @escaping (Error?, GamerModel?) -> Void) {
        DBService.firestoreDB
            .collection(GamerCollectionKeys.CollectionKey)
            .whereField(GamerCollectionKeys.GamerIDKey, isEqualTo: gamerID)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(error, nil)
                } else if let snapshot = snapshot?.documents.first {
                    let gameCreator = GamerModel(dict: snapshot.data())
                    completion(nil, gameCreator)
                }
        }
    }
    
    static public func fetchGamerBasedOnUserName(userName: String, completion: @escaping(Error?, GamerModel?) -> Void) {
        DBService.firestoreDB
            .collection(GamerCollectionKeys.CollectionKey)
            .whereField(GamerCollectionKeys.UserNameKey, isEqualTo: userName)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(error, nil)
                } else if let snapshot = snapshot?.documents.first {
                    let gameCreator = GamerModel(dict: snapshot.data())
                    completion(nil, gameCreator)
                }
        }
    }
    
    static public func fetchGamersBasedOnUserName(userName: String, completion: @escaping(Error?, [GamerModel]?) -> Void) {
        DBService.firestoreDB
            .collection(GamerCollectionKeys.CollectionKey)
            .whereField(GamerCollectionKeys.UserNameKey, isEqualTo: userName)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(error, nil)
                } else if let snapshot = snapshot?.documents {
                    var gamers = [GamerModel]()
                    for gamer in snapshot {
                        gamers.append(GamerModel(dict: gamer.data()))
                    }
                    completion(nil, gamers)
                }
        }
    }
    
    static public func fetchAllGamers(completion: @escaping(Error?, [GamerModel]?) -> Void) {
        let query = firestoreDB.collection(GamerCollectionKeys.CollectionKey)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(error, nil)
            }
            if let snapshot = snapshot {
                var gamers = [GamerModel]()
                for document in snapshot.documents {
                    let allGamers = GamerModel.init(dict: document.data())
                    gamers.append(allGamers)
                }
                completion(nil, gamers)
            }
        }
    }

    static public func deleteAccount(user: GamerModel, completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB
            .collection(GamerCollectionKeys.CollectionKey)
            .document(user.gamerID)
            .delete { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
}
