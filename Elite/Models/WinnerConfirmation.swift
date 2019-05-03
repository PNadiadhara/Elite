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
    let winnerConfirmationId: String?
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
    
    init(gameId: String, winnerConfirmationId: String?, bluePlayerOne: String?, bluePlayerTwo: String?, bluePlayerThree: String?, bluePlayerFour: String?,bluePlayerFive: String?, redPlayerOne: String?,  redPlayerTwo: String?, redPlayerThree: String?, redPlayerFour: String?, redPlayerFive: String?) {
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
    
    
    static func calculateWinner(winnerConfirmation: WinnerConfirmation, completion: @escaping(Teams?, Bool?, Int?) -> Void){
        var blueCount = 0
        var redCount = 0
        var totalCount = 0
        if let bluePlayerOne = winnerConfirmation.bluePlayerOne {
            if bluePlayerOne ==  Teams.blueTeam.rawValue {
                blueCount += 1
                totalCount += 1
            }
            if bluePlayerOne == Teams.redTeam.rawValue {
                redCount += 1
                totalCount += 1
            }
        }
        
        if let bluePlayerTwo = winnerConfirmation.bluePlayerTwo {
            if bluePlayerTwo ==  Teams.blueTeam.rawValue {
                blueCount += 1
                totalCount += 1
            }
            
            if bluePlayerTwo == Teams.redTeam.rawValue {
                redCount += 1
                totalCount += 1
            }
        }
        
        if let bluePlayerThree = winnerConfirmation.bluePlayerThree {
            if bluePlayerThree ==  Teams.blueTeam.rawValue {
                blueCount += 1
                totalCount += 1
            }
            if bluePlayerThree == Teams.redTeam.rawValue {
                redCount += 1
                totalCount += 1
            }
        }
        
        if let bluePlayerFour = winnerConfirmation.bluePlayerFour {
            if bluePlayerFour ==  Teams.blueTeam.rawValue {
                blueCount += 1
                totalCount += 1
            }
            if bluePlayerFour == Teams.redTeam.rawValue {
                redCount += 1
                totalCount += 1
            }
        }
        
        if let bluePlayerFive = winnerConfirmation.bluePlayerFive {
            if bluePlayerFive ==  Teams.blueTeam.rawValue {
                blueCount += 1
                totalCount += 1
            }
            if bluePlayerFive == Teams.redTeam.rawValue {
                redCount += 1
                totalCount += 1
            }
        }
        
        if let redPlayerOne = winnerConfirmation.redPlayerOne {
            if redPlayerOne == Teams.redTeam.rawValue {
                redCount += 1
                totalCount += 1
            }
            if redPlayerOne == Teams.blueTeam.rawValue {
                blueCount += 1
                totalCount += 1
            }
        }
        
        if let redPlayerTwo = winnerConfirmation.redPlayerTwo {
            if redPlayerTwo == Teams.redTeam.rawValue {
                redCount += 1
                totalCount += 1
            }
            if redPlayerTwo == Teams.blueTeam.rawValue {
                blueCount += 1
                totalCount += 1
            }
        }
        
        if let redPlayerThree = winnerConfirmation.redPlayerThree {
            if redPlayerThree == Teams.redTeam.rawValue {
                redCount += 1
                totalCount += 1
            }
            if redPlayerThree == Teams.blueTeam.rawValue {
                blueCount += 1
                totalCount += 1
            }
        }
        
        if let redPlayerFour = winnerConfirmation.redPlayerFour {
            if redPlayerFour == Teams.redTeam.rawValue {
                redCount += 1
                totalCount += 1
            }
            if redPlayerFour == Teams.blueTeam.rawValue {
                blueCount += 1
                totalCount += 1
            }
        }
        
        if let redPlayerFive = winnerConfirmation.redPlayerFive {
            if redPlayerFive == Teams.redTeam.rawValue {
                redCount += 1
                totalCount += 1
            }
            if redPlayerFive == Teams.blueTeam.rawValue {
                blueCount += 1
                totalCount += 1
            }
        }
        if redCount > blueCount {
            completion(Teams.redTeam, nil, totalCount)
        } else {
            completion(Teams.blueTeam, nil, totalCount)
        }
        if redCount == blueCount {
            completion(nil, true, totalCount)
        }
        
    }
//    static func checkEveryPlayerHasVoted(gameType: GameType, winningConfimation: WinnerConfirmation, completion: @escaping(Bool) -> Void) {
//
//        switch gameType {
//        case .oneVsOne:
//            var counter = 0
//            if let winningConfimation
//            if counter == 2{
//            completion(true)
//            }
//        default:
//            <#code#>
//        }
//    }
    
    
    
    
    
}
