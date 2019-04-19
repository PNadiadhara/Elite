//
//  DBService+WinnerConfirmation.swift
//  Elite
//
//  Created by Leandro Wauters on 4/19/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

extension DBService {
    
    static func postWinnerConfirmation(winningConfirmation: WinnerConfirmation, completion: @escaping (Error?, String?) -> Void) {
        let ref = firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document()
        DBService.firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(ref.documentID).setData([WinnerConfirmationKeys.gameIdKey : ref.documentID, WinnerConfirmationKeys.bluePlayerOneKey : winningConfirmation.bluePlayerOne ?? "N/A", WinnerConfirmationKeys.bluePlayerTwoKey : winningConfirmation.bluePlayerTwo ?? "N/A", WinnerConfirmationKeys.bluePlayerThreeKey : winningConfirmation.bluePlayerThree ?? "N/A", WinnerConfirmationKeys.bluePlayerFourKey : winningConfirmation.bluePlayerFour ?? "N/A", WinnerConfirmationKeys.bluePlayerFiveKey : winningConfirmation.bluePlayerFive ?? "N/A", ]) { (error) in
            if let error = error {
                completion(error,nil)
            } else {
                firestoreDB.collection(WinnerConfirmationKeys.collectionKey).document(ref.documentID).setData([WinnerConfirmationKeys.redPlayerOneKey : winningConfirmation.redPlayerOne ?? "N/A",  WinnerConfirmationKeys.redPlayerTwoKey : winningConfirmation.redPlayerTwo ?? "N/A", WinnerConfirmationKeys.redPlayerThreeKey : winningConfirmation.redPlayerThree ?? "N/A", WinnerConfirmationKeys.redPlayerFourKey : winningConfirmation.redPlayerFour ?? "N/A", WinnerConfirmationKeys.redPlayerFiveKey : winningConfirmation.redPlayerFive ?? "N/A"], completion: { (error) in
                    completion(error, ref.documentID)
                })
            }
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
        DBService.firestoreDB.collection(WinnerConfirmationKeys.collectionKey).whereField(WinnerConfirmationKeys.gameIdKey, isEqualTo: gameId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                let winningComfirmations = snapshot.documents.map{WinnerConfirmation.init(dict: $0.data())}
                completion(nil, winningComfirmations.first)
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
