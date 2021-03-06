//
//  CurrentPlayer.swift
//  Elite
//
//  Created by Leandro Wauters on 4/18/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

struct CurrentPlayersCollectionKeys {
    static let collectionKey = "currentPlayer"
    static let currentPlayerIdKey = "currentPlayerId"
    static let gamerIdKey = "gamerId"
    static let userNameKey = "userName"
    static let teamRoleKey = "teamRole"
    static let gameIdKey = "gameIdKey"

}

struct CurrentPlayer: Codable {
    let currentPlayerId: String
    let gamerId: String
    let userName: String
    let teamRole: String
    let gameId: String
    
    init(currentPlayerId: String,gamerId: String, userName: String, teamRole: String, gameId: String) {
        self.currentPlayerId = currentPlayerId
        self.gamerId = gamerId
        self.userName = userName
        self.teamRole = teamRole
        self.gameId = gameId
    }
    
    init(dict: [String:Any]) {
        self.currentPlayerId = dict[CurrentPlayersCollectionKeys.currentPlayerIdKey] as? String ?? "N/A"
        self.gamerId = dict[CurrentPlayersCollectionKeys.gamerIdKey] as? String ?? "N/A"
        self.userName = dict[CurrentPlayersCollectionKeys.userNameKey] as? String ?? "N/A"
        self.teamRole = dict[CurrentPlayersCollectionKeys.teamRoleKey] as? String ?? "N/A"
        self.gameId = dict[CurrentGameCollectionKeys.GameIdKey] as? String ?? "N/A"
    }
}
