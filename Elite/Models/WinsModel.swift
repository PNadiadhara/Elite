//
//  WinsModel.swift
//  Elite
//
//  Created by Manny Yusuf on 4/4/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class WinsModel {
    let gameName: String
    let gamer: String
    let location: String
    let scoreCount: Int
    
    init(gameName: String,
         gamer: String,
         location: String,
         scoreCount: Int) {
        self.gameName = gameName
        self.gamer = gamer
        self.location = location
        self.scoreCount = scoreCount
    }
}
