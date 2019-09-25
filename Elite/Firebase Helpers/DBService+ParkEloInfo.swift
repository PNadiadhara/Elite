//
//  DBService+ParkEloInfo.swift
//  Elite
//
//  Created by Manny Yusuf on 4/15/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct ParkEloInfoCollectionKeys {
    static let UserIDKey = "userID"
    static let ParkIDKey = "parkID"
    static let HighestBasketballEloKey = "highestBasketballElo"
    static let CurrentBasketballEloKey = "currentBasketballElo"
    static let HighestHandballEloKey = "highestHandballElo"
    static let CurrentHandballEloKey = "game"
}

enum WinningStatus: Double {
    case win = 1
    case lose = 0
    case tie = 0.5
}

// Rn = Ro + K * (WinningStatus.rawvalue - E)
final class EloRankings {
    
    // Ro will be given from GamerModel
    // This function solves for Rn
    
    public static func calculateElo ( playerRatingPreMatch: Double,numberOfGamesPlayed: Double, playerMaxElo: Double, actualGameScore : WinningStatus, playerBRatingPreMatch: Double ) -> Double {
        var newRating = 0.0
        
        newRating = playerRatingPreMatch + kFactorSelector(numberOfGamesPlayed: numberOfGamesPlayed, playerMaxElo: playerMaxElo) * (actualGameScore.rawValue - calculateExpectedGameScore(playerARatingPreMatch: playerRatingPreMatch, playerBRatingPreMatch: playerBRatingPreMatch))
        return newRating
    }
    
    // Return K based on number of games played for that sport
    // Rn = Ro + kFactorSelector * (WinningStatus.rawvalue - E)
    public static func kFactorSelector(numberOfGamesPlayed : Double, playerMaxElo : Double) -> Double {
        // this if is for first time placements
        var kFactor = 10.0
        
        if numberOfGamesPlayed < 20.0 {
            kFactor = 40
        } else if playerMaxElo < 2400.00 {
            kFactor = 20
        } else if  playerMaxElo >= 2400.00 {
            kFactor = 10
        }
        return kFactor
    }
    
    // this solves for E
    // Rn = Ro + kFactorSelector * (WinningStatus.rawvalue - calculateExpectedGameScore)
    public static func calculateExpectedGameScore( playerARatingPreMatch: Double, playerBRatingPreMatch: Double ) -> Double {
        // e is euler's constant
        // https://en.wikipedia.org/wiki/E_(mathematical_constant)
        let e = 2.71828
        let x = playerARatingPreMatch - playerBRatingPreMatch
        let n = 400.00
        let exponent = -(x/n)
        let expectedGameScore = 1.00/(1 + pow(e, exponent))
        return expectedGameScore
    }
    
}


