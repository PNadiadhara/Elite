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
}
extension DBService {
    static public func createUser(gamer: GamerModel, completion: @escaping (Error?) -> Void) {
        firestoreDB.collection(GamerCollectionKeys.CollectionKey)
            .document(gamer.gamerID)
            .setData([ GamerCollectionKeys.ProfileImageURLKey : gamer.profileImage ?? "",
                       GamerCollectionKeys.FirstNameKey : gamer.firstname,
                       GamerCollectionKeys.LastNameKey : gamer.lastname,
                       GamerCollectionKeys.UserNameKey : gamer.username,
                       GamerCollectionKeys.EmailKey : gamer.email,
                       GamerCollectionKeys.StatusKey : gamer.status ?? "",
                       GamerCollectionKeys.AchievementsKey : gamer.achievements ?? "",
                       GamerCollectionKeys.BioKey : gamer.bio ?? "",
                       GamerCollectionKeys.QRcodeKey : gamer.qrCode,
                       GamerCollectionKeys.JoinedDateKey  : gamer.joinedDate,
                       GamerCollectionKeys.GamerIDKey : gamer.gamerID,
                       GamerCollectionKeys.FriendsKey : gamer.friends ?? ""
                    
            ]) { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
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
}
