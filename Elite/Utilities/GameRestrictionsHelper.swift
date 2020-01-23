//
//  GameRestrictionsHelper.swift
//  Elite
//
//  Created by Leandro Wauters on 7/14/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

class GameRestrictionsHelper {
    
    static var test = true
    //TO DO: Limit player to only play each other 3 times a day
    static public func checkIfGameIsWithin20Mins(gamerId: String, completion: @escaping (Error?, Bool?, Int?) -> Void) {
        DBService.fetchPlayersGamesPlayed(gamerId: gamerId) { (error, gamesPlayed) in
            if let error = error {
                completion(error,nil, nil)
            }
            if let gamesPlayed = gamesPlayed {
                for game in gamesPlayed {
                    let gameCreated = game.gameCreatedTime.date()
                    guard let timeDifference = Calendar.current.dateComponents([.minute], from: gameCreated, to: Date()).minute else {return}
                    guard let timeInSeconds = Calendar.current.dateComponents([.second], from: gameCreated, to: Date()).second else {return}
                    if timeDifference >= 20 {
                        completion(nil, true, nil) // Okay To play
                    } else {
                        completion(nil, false, timeInSeconds) // Not okay
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
                    let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
                    let gameEndDate = game.gameEndTime?.stringToDate(format: "MMM d, yyyy hh:mm a")
                    guard let timeDifference = Calendar.current.dateComponents(dayHourMinuteSecond, from: gameEndDate!, to: Date()).hour else {return}
                    if timeDifference <= 12 {
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
