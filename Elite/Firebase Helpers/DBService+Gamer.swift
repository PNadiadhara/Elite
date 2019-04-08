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
    static let BioKey = "bio"
    static let QRcodeKey = "qrCode"
    static let JoinedDateKey = "joinedDate"
    static let GamerIDKey = "gamerID"
}
extension DBService {
    static public func createUser(gamer: GamerModel, completion: @escaping (Error?) -> Void) {
        firestoreDB.collection(GamerCollectionKeys.CollectionKey)
            .document(gamer.gamerID)
            .setData([ GamerCollectionKeys.GamerIDKey : gamer.gamerID,
                       GamerCollectionKeys.UserNameKey : gamer.username,
                       GamerCollectionKeys.EmailKey       : gamer.email,
                       GamerCollectionKeys.ProfileImageURLKey    : gamer.profileImage ?? "",
                       GamerCollectionKeys.JoinedDateKey  : gamer.joinedDate,
                       GamerCollectionKeys.BioKey         : gamer.bio ,
                       GamerCollectionKeys.FirstNameKey   : gamer.firstname,
                       GamerCollectionKeys.LastNameKey    : gamer.lastname
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
}
