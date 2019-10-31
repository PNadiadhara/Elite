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
    static let PlayerWins = "playerWins"
}

struct NewBasketBallCollectionKeys {
    static let CollectionKey = "BasketBallCourts"
    static let Prop_ID = "Prop_ID"
    static let PlayerWins = "playerWins"
}

extension DBService {
    
    static public func fetchBasketBallParkId(parkName: String, completion: @escaping(Error?, String?) -> Void){
        
        fetchBasketBallParks { (error, basketBallCourts) in
            if let error = error {
                completion(error, nil)
            }
            if let basketBallCourts = basketBallCourts {
                let match = basketBallCourts.filter{$0.name == parkName}.first
                if let result = match {
                    completion(nil,result.propertyID)
                } else {
                    print("No park found")
                }
            }
        }
    }
    static func fetchBasketBallPark(parkId: String, completion: @escaping(Error?, BasketBallData?) -> Void) {
        DBService.firestoreDB.collection(NewBasketBallCollectionKeys.CollectionKey).whereField(NewBasketBallCollectionKeys.Prop_ID, isEqualTo: parkId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(error, nil)
            } else if let snapshot = snapshot?.documents.first {
                let BBCourt = BasketBallData(dict: snapshot.data())
                completion(nil, BBCourt)
            }
        }
    }
    
    static public func updatePlayersWinsBasketBall(parkId: String, playerId: String, sport: String, completion: @escaping (Error?) -> Void) {
        fetchBasketBallPark(parkId: parkId) { (error, basketBallCourt) in
            
            if let error = error {
                completion(error)
            }
            if let basketBallCourt = basketBallCourt {
            guard var playersWins = basketBallCourt.playersWins else {
                    DBService.firestoreDB.collection(NewBasketBallCollectionKeys.CollectionKey).document(parkId).updateData([NewBasketBallCollectionKeys.PlayerWins : [playerId : 1]], completion: { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    })
                    return
                }
                if let wins = playersWins[playerId] {
                    playersWins[playerId] = wins + 1
                } else {
                    playersWins[playerId] = 1
                }
                DBService.firestoreDB.collection(NewBasketBallCollectionKeys.CollectionKey).document(parkId).updateData([NewBasketBallCollectionKeys.PlayerWins: playersWins],       completion: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                })
            }
        }
    }
    static func getBBRankingByPark(parkId: String, completion: @escaping(Error?, [GamerModel]?) -> Void) {
        getBasketBallSortedDict(parkId: parkId) { (error, sortedPlayerWinsDict) in
            
            if let error = error {
                completion(error,nil)
            }
            if let sortedPlayerWinsDict = sortedPlayerWinsDict {
                var BBPlayers = [GamerModel]()
                for (player, _) in sortedPlayerWinsDict {
                    fetchGamer(gamerID: player, completion: { (error, gamer) in
                        if let error = error {
                            completion(error , nil)
                        }
                        if let gamer = gamer {
                            BBPlayers.append(gamer)
                            completion(nil , BBPlayers)
                        }
                    })
                }
                
            }
        }
    }
    static public func getBasketBallSortedDict(parkId: String, completion: @escaping(Error?, [(key: String, value: Int)]?) -> Void) {
        // Set<String>
        
        fetchBasketBallPark(parkId: parkId) { (error, BBCourt) in
            if let error = error {
                completion(error,nil)
            }
            if let BBCourt = BBCourt {
                guard let playerWins = BBCourt.playersWins else {
                    let error = NSError(domain:"No players found in park", code: 0, userInfo:nil)
                    completion(error, nil)
                    return
                }
                let sortedPlayerWinsDict = playerWins.sorted { $0.1 > $1.1 }
                completion(nil, sortedPlayerWinsDict)
                
            }
        }
    }
    static func addBbCollection(completion: @escaping () -> Void) {
        DBService.fetchHandBallParks { (error, basketball) in
            if let error = error {
                
            }
            if let bbs = basketball {
                for bb in bbs {
                    let bbCourt = bb
                    firestoreDB.collection("HandBallCourts").document(bbCourt.propertyID).setData([ParkCollectionKeys.Prop_ID : bbCourt.propertyID ?? "",
                                                                                                     ParkCollectionKeys.Accessible : bbCourt.accessible ?? "",
                                                                                                     ParkCollectionKeys.Location : bbCourt.location ?? "",
                                                                                                     ParkCollectionKeys.Name : bbCourt.name,
                                                                                                     ParkCollectionKeys.Num_of_Courts : bbCourt.numberOfCourts ?? "",
                                                                                                     ParkCollectionKeys.Lat : bbCourt.latitude ?? "",
                                                                                                     ParkCollectionKeys.Lon: bbCourt.longitude ?? "",
                                                                                                     ParkCollectionKeys.PlayerWins : nil], completion: { (error) in
                            if let error = error {
                               print("Error \(error.localizedDescription)")
                            }
                    })
                    completion()
                }
                
            }
           
        }
        
    }
    static public func fetchHandBallParkId(parkName: String) -> String {
        var parkId = String()
        fetchHandBallParks { (error, handBallCourts) in
            if let error = error {
                print("Error fetching parks: \(error.localizedDescription)")
            }
            if let handBallCourt = handBallCourts {
                let match = handBallCourt.filter{$0.name == parkName}.first
                if let result = match {
                    parkId = result.propertyID
                } else {
                    print("No park found")
                }
            }
        }
        return parkId
    }
    
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
