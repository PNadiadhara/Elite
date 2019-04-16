//
//  ParkEloInfoModel.swift
//  Elite
//
//  Created by Manny Yusuf on 4/15/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class ParkEloInfoModel {
    
    let userID: Int
    let parkID: Int
    let highestBasketballElo: Int
    let currentBasketballElo: Int
    let highestHandballElo: Int
    let currentHandballElo: Int
    
    init(userID: Int,
         parkID: Int,
         highestBasketballElo: Int,
         currentBasketballElo: Int,
         highestHandballElo: Int,
         currentHandballElo: Int) {
            self.userID = userID
            self.parkID = parkID
            self.highestBasketballElo = highestBasketballElo
            self.currentBasketballElo = currentBasketballElo
            self.highestHandballElo = highestHandballElo
            self.currentHandballElo = currentHandballElo
    }
    
    init(dict: [String: Any]) {
        self.userID = dict[ParkEloInfoCollectionKeys.UserIDKey] as? Int ?? 0
        self.parkID = dict[ParkEloInfoCollectionKeys.ParkIDKey] as? Int ?? 0
        self.highestBasketballElo = dict[ParkEloInfoCollectionKeys.HighestBasketballEloKey] as? Int ?? 0
        self.currentBasketballElo = dict[ParkEloInfoCollectionKeys.CurrentBasketballEloKey] as? Int ?? 0
        self.highestHandballElo = dict[ParkEloInfoCollectionKeys.HighestHandballEloKey] as? Int ?? 0
        self.currentHandballElo = dict[ParkEloInfoCollectionKeys.CurrentHandballEloKey] as? Int ?? 0
    }
}
