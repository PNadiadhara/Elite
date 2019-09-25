//
//  DBService+Parks.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 6/28/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct ParkCollectionKeys {
    static let CollectionKey = "parks"
    static let DocumentKey1 = "courts"
    static let DocumentKey2 = "courts1"
    static let ArrayFieldKey = "basketball"
    static let Accessible = "Accessible"
    static let Location = "Location"
    static let Name = "Name"
    static let Num_of_Courts = "Num_of_Courts"
    static let Prop_ID = "Prop_ID"
    static let Lat = "lat"
    static let Lon = "lon"
}

extension DBService {
    static public func fetchBasketBallParks(completion: @escaping (Error?,[BasketBallData]?) -> Void){
        // working on
        let docRef = firestoreDB.collection(ParkCollectionKeys.CollectionKey)
            .document(ParkCollectionKeys.DocumentKey1)
        docRef.getDocument { (doc, error) in
            if let error = error {
                completion(error, nil)
            }
            else if let doc = doc {
                if let dict = doc.data() {
                    if let values = dict["basketball"] as? [Any] {
                        print(values.count) // 562
                        var courts = [BasketBallData]()
                        for valueDict in values {
                            if let dict = valueDict as? [String: Any] {
                                let court = BasketBallData(dict: dict)
                                courts.append(court)
                            }
                        }
                        completion(nil, courts)
                    }
                }
                //print("Document info: \(doc.data())")
            }
            if let error = error {
                print("Error fetching parks \(error.localizedDescription)")
            }
        }
    
    }
    
    static public func fetchHandBallParks(completion: @escaping (Error?,[HandBallData]?) -> Void){
        let docRef = firestoreDB.collection(ParkCollectionKeys.CollectionKey)
            
        .document(ParkCollectionKeys.DocumentKey2)
        
        docRef.getDocument { (doc, error) in
            if let error = error {
                completion(error,nil)
            }
            
            else if let doc = doc {
                if let dict = doc.data() {
                    if let values = dict["handball"] as? [Any] {
                        print(values.count) // 562
                        var courts = [HandBallData]()
                        for valueDict in values {
                            if let dict = valueDict as? [String: Any] {
                                let court = HandBallData(dict: dict)
                                courts.append(court)
                            }
                        }
                        completion(nil, courts)
                    }
                }
                //print("Document info: \(doc.data())")
            }
            
        }
        
        
    }
    
    static public func updateCoord(){
        // working on
        
        let docRef = firestoreDB.collection(ParkCollectionKeys.CollectionKey)
            
            .document(ParkCollectionKeys.DocumentKey2)
        
    }
}
