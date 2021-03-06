//
//  Message.swift
//  Elite
//
//  Created by Leandro Wauters on 4/15/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

struct InvitationCollectionKeys {
    static let collectionKey = "invitation"
    static let invitationIdKey = "invitationId"
    static let gameIdKey = "gameId"
    static let senderIdKey = "sender"
    static let recieverKey = "reciever"
    static let messageKey = "message"
    static let approvalKey = "approval"
    static let latKey = "lat"
    static let lonKey = "lon"
    static let gameKey = "game"
    static let senderUsernameKey = "senderUsername"
    static let gameTypeKey = "gameType"
}
class Invitation {
    let invitationId: String
    let gameId: String
    let sender: String
    let reciever: String
    let message: String
    let approval: Bool
    let lat: Double
    let lon: Double
    let game: String
    let senderUsername: String
    let gameType: String
    
    init(invitationId: String, gameId: String, sender: String, reciever: String, message: String, approval: Bool,lat: Double, lon: Double, game: String, senderUsername: String, gameType: String) {
        self.invitationId = invitationId
        self.gameId = gameId
        self.sender = sender
        self.reciever = reciever
        self.message = message
        self.approval = approval
        self.lat = lat
        self.lon = lon
        self.game = game
        self.senderUsername = senderUsername
        self.gameType = gameType
        
    }
    init(dict: [String: Any]) {
        self.invitationId = dict[InvitationCollectionKeys.invitationIdKey] as? String ?? "N/A"
        self.gameId = dict[InvitationCollectionKeys.gameIdKey] as? String ?? "N/A"
        self.sender = dict[InvitationCollectionKeys.senderIdKey] as? String ?? "N/A"
        self.reciever = dict[InvitationCollectionKeys.recieverKey] as? String ?? "N/A"
        self.message = dict[InvitationCollectionKeys.messageKey] as? String ?? "N/A"
        self.approval = dict[InvitationCollectionKeys.approvalKey] as? Bool ?? false
        self.lat = dict[InvitationCollectionKeys.latKey] as? Double ?? 0.0
        self.lon = dict[InvitationCollectionKeys.lonKey] as? Double ?? 0.0
        self.game = dict[InvitationCollectionKeys.gameKey] as? String ?? "N/A"
        self.senderUsername = dict[InvitationCollectionKeys.senderUsernameKey] as? String ?? "N/A"
        self.gameType = dict[InvitationCollectionKeys.gameTypeKey] as? String ?? "N/A"
    }
}
