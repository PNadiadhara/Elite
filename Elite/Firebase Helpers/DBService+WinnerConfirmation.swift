//
//  DBService+WinnerConfirmation.swift
//  Elite
//
//  Created by Leandro Wauters on 4/19/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension DBService {
    
    static func postWinnerConfirmation(winningConfirmation: WinnerConfirmation, completion: @escaping (Error?, String?) -> Void) {
        let na = "N/A"
        let ref = firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document()
        DBService.firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(ref.documentID).setData([WinnerConfirmationKeys.winnerConfirmationIdKey : ref.documentID,
            WinnerConfirmationKeys.gameIdKey : winningConfirmation.gameId, WinnerConfirmationKeys.bluePlayerOneKey : winningConfirmation.bluePlayerOne ?? na, WinnerConfirmationKeys.bluePlayerTwoKey : winningConfirmation.bluePlayerTwo ?? na, WinnerConfirmationKeys.bluePlayerThreeKey : winningConfirmation.bluePlayerThree ?? na, WinnerConfirmationKeys.bluePlayerFourKey : winningConfirmation.bluePlayerFour ?? na, WinnerConfirmationKeys.bluePlayerFiveKey : winningConfirmation.bluePlayerFive ?? na,
        WinnerConfirmationKeys.redPlayerOneKey : winningConfirmation.redPlayerOne ?? na,  WinnerConfirmationKeys.redPlayerTwoKey : winningConfirmation.redPlayerTwo ?? na, WinnerConfirmationKeys.redPlayerThreeKey : winningConfirmation.redPlayerThree ?? na, WinnerConfirmationKeys.redPlayerFourKey : winningConfirmation.redPlayerFour ?? na, WinnerConfirmationKeys.redPlayerFiveKey : winningConfirmation.redPlayerFive ?? na]) { (error) in
            if let error = error {
                completion(error,nil)
            }
            completion(nil, ref.documentID)
        }
        
    }
    static func updateWinningConfirmation(teamSelected: String, winningConfimationId: String, currentPlayerTeamRole: String) {
        switch currentPlayerTeamRole {
        case TeamRoles.blueOne.rawValue:
            firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(winningConfimationId).updateData([WinnerConfirmationKeys.bluePlayerOneKey : teamSelected])
        
        case TeamRoles.blueTwo.rawValue:
            firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(winningConfimationId).updateData([WinnerConfirmationKeys.bluePlayerTwoKey : teamSelected])
       
        case TeamRoles.blueThree.rawValue:
            firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(winningConfimationId).updateData([WinnerConfirmationKeys.bluePlayerThreeKey : teamSelected])
        
        case TeamRoles.blueFour.rawValue:
            firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(winningConfimationId).updateData([WinnerConfirmationKeys.bluePlayerFourKey : teamSelected])
        
        case TeamRoles.blueFive.rawValue:
            firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(winningConfimationId).updateData([WinnerConfirmationKeys.bluePlayerFourKey : teamSelected])
        
        case TeamRoles.redOne.rawValue:
            firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(winningConfimationId).updateData([WinnerConfirmationKeys.redPlayerOneKey : teamSelected])
        
        case TeamRoles.redTwo.rawValue:
            firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(winningConfimationId).updateData([WinnerConfirmationKeys.redPlayerTwoKey : teamSelected])
        
        case TeamRoles.redThree.rawValue:
            firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(winningConfimationId).updateData([WinnerConfirmationKeys.redPlayerThreeKey : teamSelected])
       
        case TeamRoles.redFour.rawValue:
            firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(winningConfimationId).updateData([WinnerConfirmationKeys.redPlayerFourKey : teamSelected])
        
        case TeamRoles.redFive.rawValue:
            firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(winningConfimationId).updateData([WinnerConfirmationKeys.redPlayerFiveKey : teamSelected])
            
        default:
            print("No team role found")
        }
        
        
    }
    static func fetchWinningConfirmations(gameId: String, completion: @escaping(Error?, WinnerConfirmation?) -> Void) {
       
        var listener: ListenerRegistration!
       listener = DBService.firestoreDB.collection(WinnerConfirmationKeys.collectionKey).whereField(WinnerConfirmationKeys.gameIdKey, isEqualTo: gameId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                let winningComfirmations = snapshot.documents.map{WinnerConfirmation.init(dict: $0.data())}
                completion(nil, winningComfirmations.first)
            }
        }
        
    }
    
    static func deleteWinningConfirmation(winningConfirmationId: String, completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB
            .collection(WinnerConfirmationKeys.collectionKey)
            .document(winningConfirmationId)
            .delete { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
//    static public func updateCoverImage(blogger: Blogger, imageUrl: String){
//        firestoreDB.collection(BloggersCollectionKeys.CollectionKey).document(blogger.bloggerId).updateData([BloggersCollectionKeys.CoverImageURLKey : imageUrl]) { (error) in
//            if let error = error {
//                print(error)
//            }
//        }
//    }
}
