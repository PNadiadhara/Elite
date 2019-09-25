//
//  CurrentGame.swift
//  Elite
//
//  Created by Leandro Wauters on 4/24/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

struct CurrentGameCollectionKeys {
    static let CurrentGameColllectionKey = "currentGame"
    static let CurrentGameIdKey = "currentGameId"
    static let GameIdKey = "gameIdKey"
    static let redOneKey = "redOne"
    static let redTwoKey = "redTwo"
    static let redThreeKey = "redThree"
    static let redFourKey = "redFour"
    static let redFiveKey = "redFive"
    static let blueOneKey = "blueOne"
    static let blueTwoKey = "blueTwo"
    static let blueThreeKey = "blueThree"
    static let blueFourKey = "blueFour"
    static let blueFiveKey = "blueFive"
}

class CurrentGame {
    let currentGameId: String
    let gameId: String
    let redOne: String?
    let redTwo: String?
    let redThree: String?
    let redFour: String?
    let redFive: String?
    let blueOne: String?
    let blueTwo: String?
    let blueThree: String?
    let blueFour: String?
    let blueFive: String?
    
    init(currentGameId: String, gameId: String, redOne: String?, redTwo: String?, redThree: String?, redFour: String?, redFive: String?, blueOne:String?, blueTwo: String?, blueThree: String?, blueFour: String?, blueFive: String?) {
        self.currentGameId = currentGameId
        self.gameId = gameId
        self.redOne = redOne
        self.redTwo = redTwo
        self.redThree = redThree
        self.redFour = redFour
        self.redFive = redFive
        self.blueOne = blueOne
        self.blueTwo = blueTwo
        self.blueThree = blueThree
        self.blueFour = blueFour
        self.blueFive = blueFive
    }
    
    init(dict: [String : Any]) {
        let na = "N/A"
        self.currentGameId = dict[CurrentGameCollectionKeys.CurrentGameIdKey] as? String ?? na
        self.gameId = dict[CurrentGameCollectionKeys.GameIdKey] as? String ?? na
        self.redOne = dict[CurrentGameCollectionKeys.redOneKey] as? String ?? na
        self.redTwo = dict[CurrentGameCollectionKeys.redTwoKey] as? String ?? na
        self.redThree = dict[CurrentGameCollectionKeys.redThreeKey] as? String ?? na
        self.redFour = dict[CurrentGameCollectionKeys.redFourKey] as? String ?? na
        self.redFive = dict[CurrentGameCollectionKeys.redFiveKey] as? String ?? na
        self.blueOne = dict[CurrentGameCollectionKeys.blueOneKey] as? String ?? na
        self.blueTwo = dict[CurrentGameCollectionKeys.blueTwoKey] as? String ?? na
        self.blueThree = dict[CurrentGameCollectionKeys.blueThreeKey] as? String ?? na
        self.blueFour = dict[CurrentGameCollectionKeys.blueFourKey] as? String ?? na
        self.blueFive = dict[CurrentGameCollectionKeys.blueFiveKey] as? String ?? na
    }
}

