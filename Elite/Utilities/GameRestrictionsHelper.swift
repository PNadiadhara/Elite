//
//  GameRestrictionsHelper.swift
//  Elite
//
//  Created by Leandro Wauters on 7/14/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class GameRestrictionsHelper {
    //TO DO: Limit player to only play each other 3 times a day
    static public func checkIfGameIsWithin20Mins(gamerId: String, completion: @escaping (Error?, Bool?) -> Void) {
        DBService.fetchPlayersGamesPlayed(gamerId: gamerId) { (error, gamesPlayed) in
            if let error = error {
                completion(error,nil)
            }
            if let gamesPlayed = gamesPlayed {
                for game in gamesPlayed {
                    let gameEndDate = game.gameEndTime?.stringToDate()
                    let timeSinceLastGame = Calendar.current.component(.minute, from: gameEndDate!)
                    let timeNow = Calendar.current.component(.minute, from: Date())
                    if timeNow - timeSinceLastGame >= 20 {
                        completion(nil, true)
                    } else {
                        completion(nil, false)
                    }
                }
            }
        }
    }
    
    static public func checkFor3GamesADayLimit(gamersId: String, completion: @escaping(Error?,Bool?) -> Void) {
        DBService.fetchGamesWherePlayersPlayedEachOther(gamersId: gamersId) { (error, gamesPlayedAgainstEachOther) in
            if let error = error {
                completion(error, nil)
            }
            if let gamesPlayedAgainstEachOther = gamesPlayedAgainstEachOther {
                var count = 0
                for game in gamesPlayedAgainstEachOther {
                    let gameEndDate = game.gameEndTime?.date()
                    let timeSinceLastGame = Calendar.current.component(.hour, from: gameEndDate!)
                    let timeNow = Calendar.current.component(.hour, from: Date())
                    if timeNow - timeSinceLastGame <= 24 {
                        count += 1
                    }
                }
                if count >= 3 {
                    completion(nil, true)
                } else {
                    completion(nil, false)
                }
            }
        }
    }
}
