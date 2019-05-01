//
//  EloRankMethods.swift
//  Elite
//
//  Created by Pritesh Nadiadhara on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

// Elo Ranking and equtionatin
// https://blog.mackie.io/the-elo-algorithm

// k factor will adjust based on users # of games played
// higher k factors create more volitile shifts in elo ranking, with lower k factor resulting in less volitile shifts

// K=40 for new players until they play 30 games
// K=20 for players with > 30 games and never had an ELO > 2400
// K=10 for players with > 30 games and have had an ELO > 2400
// n value is the same as FIDE(chess elo ranking) this is always a positive value
// these results for n factor of 400. (n is const set arbitrarily, used by the world chess federation)
//


// Final equation is Rn = Ro + K * (S - E)



final class EloRanking {
    
    enum WinningStatus: Double {
        case win = 1
        case lose = 0
        case tie = 0.5
    }
    
    
    
    public func calculateElo ( playerRatingPreMatch: Double, expectedGameScore: Double, acutalGameScore: Double, kFactor : Double ) -> Double {
        var newRating = 0.0
        
        newRating = playerRatingPreMatch + kFactor * (acutalGameScore - expectedGameScore)
        return newRating
    }
    
    public func avarageTeamEloRatingofEnd (team : [Double]) -> Double {
        var teamAerageElo = 0.0
        for member in team {
            teamAerageElo += member
        }
        teamAerageElo = teamAerageElo / Double(team.count)
        
        return teamAerageElo
    
    }
    
    
    
    public func calculateExpectedGameScore( playerARatingPreMatch: Double, playerBRatingPreMatch: Double ) -> Double {
        // e is euler's constant
        // https://en.wikipedia.org/wiki/E_(mathematical_constant)
        let e = 2.71828
        let x = playerARatingPreMatch - playerBRatingPreMatch
        let n = 400.00
        let exponent = -(x/n)
        let expectedGameScore = 1.00/(1 + pow(e, exponent))
        
        return expectedGameScore
    }
    
    
    
    public func calculateActualScore(players: [String], winningStatus : WinningStatus) -> Double {
        
        // TODO:
        
        return winningStatus.rawValue
    }
    
    
}
