//
//  DBService+CurrentGame.swift
//  Elite
//
//  Created by Leandro Wauters on 4/24/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import Firebase

extension DBService {
    static func postCurrentGame(currentGame: CurrentGame, completion: @escaping (Error?) -> Void) {
        let na = "N/A"
        let ref = firestoreDB.collection(CurrentGameCollectionKeys.CurrentGameColllectionKey).document()
        ref.setData(
            [CurrentGameCollectionKeys.CurrentGameIdKey : ref.documentID,
                CurrentGameCollectionKeys.redOneKey : currentGame.redOne ?? na,
                CurrentGameCollectionKeys.redTwoKey : currentGame.redTwo ?? na,
                CurrentGameCollectionKeys.redThreeKey: currentGame.redThree ?? na,
                CurrentGameCollectionKeys.redFourKey : currentGame.redFour ?? na,
                CurrentGameCollectionKeys.redFiveKey : currentGame.redFive ?? na,
                CurrentGameCollectionKeys.blueOneKey: currentGame.blueOne ?? na,
                CurrentGameCollectionKeys.blueTwoKey : currentGame.blueTwo ?? na,
                CurrentGameCollectionKeys.blueThreeKey: currentGame.blueThree ?? na,
                CurrentGameCollectionKeys.blueFourKey : currentGame.blueFour ?? na,
                CurrentGameCollectionKeys.blueFiveKey : currentGame.blueFive ?? na ]) { (error) in
                    if let error = error {
                        completion(error)
                    }
        }
    }
    static func fetchCurrentGame(gameId: String, completion: @escaping(Error?, CurrentGame?) -> Void) {
        var listener: ListenerRegistration!
        listener = DBService.firestoreDB.collection(CurrentGameCollectionKeys.CurrentGameColllectionKey).whereField(CurrentGameCollectionKeys.GameIdKey, isEqualTo: gameId).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                let currentGame = snapshot.documents.map{CurrentGame.init(dict: $0.data())}
                completion(nil, currentGame.first)
            }
        })
    }
}
