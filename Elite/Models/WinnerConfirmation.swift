//
//  WinnerConfirmation.swift
//  Elite
//
//  Created by Leandro Wauters on 4/18/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

struct WinnerConfirmationKeys {
    static let collectionKey = "winnerConfirmation"
    static let gameIdKey = "gameId"
    static let winnerConfirmationIdKey = "winnerConfirmationId"
    static let bluePlayerOneKey = "bluePlayerOne"
    static let bluePlayerTwoKey = "bluePlayerTwo"
    static let bluePlayerThreeKey = "bluePlayerThree"
    static let bluePlayerFourKey = "bluePlayerFour"
    static let bluePlayerFiveKey = "bluePlayerFive"
    static let redPlayerOneKey = "redPlayerOne"
    static let redPlayerTwoKey = "redPlayerTwo"
    static let redPlayerThreeKey = "redPlayerThree"
    static let redPlayerFourKey = "redPlayerFour"
    static let redPlayerFiveKey = "redPlayerFive"
    
}

class WinnerConfirmation {
    let gameId: String
    let winnerConfirmationId: String
    let bluePlayerOne: String?
    let bluePlayerTwo: String?
    let bluePlayerThree: String?
    let bluePlayerFour: String?
    let bluePlayerFive: String?
    let redPlayerOne: String?
    let redPlayerTwo: String?
    let redPlayerThree: String?
    let redPlayerFour: String?
    let redPlayerFive: String?
    
    init(gameId: String, winnerConfirmationId: String, bluePlayerOne: String?, bluePlayerTwo: String?, bluePlayerThree: String?, bluePlayerFour: String?,bluePlayerFive: String?, redPlayerOne: String?,  redPlayerTwo: String?, redPlayerThree: String?, redPlayerFour: String?, redPlayerFive: String?) {
        self.gameId = gameId
        self.winnerConfirmationId = winnerConfirmationId
        self.bluePlayerOne = bluePlayerOne
        self.bluePlayerTwo = bluePlayerTwo
        self.bluePlayerThree = bluePlayerThree
        self.bluePlayerFour = bluePlayerFour
        self.bluePlayerFive = bluePlayerFive
        self.redPlayerOne = redPlayerOne
        self.redPlayerTwo = redPlayerTwo
        self.redPlayerThree = redPlayerThree
        self.redPlayerFour = redPlayerFour
        self.redPlayerFive = redPlayerFive
    }
    
    init(dict: [String: Any]) {
        self.gameId = dict[WinnerConfirmationKeys.gameIdKey] as? String ?? "N/A"
        self.winnerConfirmationId = dict[WinnerConfirmationKeys.winnerConfirmationIdKey] as? String ?? "N/A"
        self.bluePlayerOne = dict[WinnerConfirmationKeys.bluePlayerOneKey] as? String ?? "N/A"
        self.bluePlayerTwo = dict[WinnerConfirmationKeys.bluePlayerTwoKey] as? String ?? "N/A"
        self.bluePlayerThree = dict[WinnerConfirmationKeys.bluePlayerThreeKey] as? String ?? "N/A"
        self.bluePlayerFour = dict[WinnerConfirmationKeys.bluePlayerFourKey] as? String ?? "N/A"
        self.bluePlayerFive = dict[WinnerConfirmationKeys.bluePlayerFiveKey] as? String ?? "N/A"
        self.redPlayerOne = dict[WinnerConfirmationKeys.redPlayerOneKey] as? String ?? "N/A"
        self.redPlayerTwo = dict[WinnerConfirmationKeys.redPlayerTwoKey] as? String ?? "N/A"
        self.redPlayerThree = dict[WinnerConfirmationKeys.redPlayerThreeKey] as?
            String ?? "N/A"
        self.redPlayerFour = dict[WinnerConfirmationKeys.redPlayerFourKey] as?
        String ?? "N/A"
        self.redPlayerFive = dict[WinnerConfirmationKeys.redPlayerFiveKey] as? String ?? "N/A"
    }
    
    
    
    
    
    
    
    
}
