//
//  RankingHelper.swift
//  Elite
//
//  Created by Leandro Wauters on 10/30/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation


class RankingHelper {
    
    public func findPlayerRanking(gamerId: String, parkId: String, sport: String, completion: @escaping(Error?, Int?) -> Void) {
        var ranking = 1
        findRankingByPark(parkId: parkId, sport: sport) { gamers, error in
            if let error = error {
              completion(error,nil)
            }
            if let gamers = gamers {
                for gamer in gamers {
                    if gamer.gamerID == gamerId{
                        completion(nil , ranking)
                    } else {
                        ranking += 1
                    }
                }
            }
        }
        
    }
    
    public func findRankingByPark(parkId: String, sport: String, completion: @escaping ([GamerModel]?, Error?) -> Void) {
        DBService.fetchAllGamers { error, gamers in
            if let error = error {
                completion(nil, error)
            }
            var gamersAtPark = [GamerModel]()
            if let gamers = gamers {
//                let sortedByValueDictionary = myDictionary.sorted { $0.1 < $1.1 }
                var rankedGamers: [GamerModel]
                for gamer in gamers {
                    if sport == SportType.basketball.rawValue {
                        if (gamer.basketBallGamesWinsByLocation?[parkId]) != nil {
                            gamersAtPark.append(gamer)
                        }
                        rankedGamers = gamersAtPark.sorted(by: {($0.basketBallGamesWinsByLocation![parkId]!) > $1.basketBallGamesWinsByLocation![parkId]!})
                        completion(rankedGamers, nil)
                    }
                    if sport == SportType.handball.rawValue {
                        if (gamer.handBallWinsPlayedByLocation?[parkId]) != nil {
                            gamersAtPark.append(gamer)
                        }
                        rankedGamers = gamersAtPark.sorted(by: {($0.handBallWinsPlayedByLocation![parkId]!) > $1.handBallWinsPlayedByLocation![parkId]!})
                        completion(rankedGamers, nil)
                    }

                }
//                let rankedGamers = gamersAtPark.sorted(by: {($0.basketBallGamesWinsByLocation![parkId]!) > $1.basketBallGamesWinsByLocation![parkId]!})
                //completion(rankedGamers, nil)
            }
        }
    }
}
