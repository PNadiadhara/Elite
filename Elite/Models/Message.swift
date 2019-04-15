//
//  Message.swift
//  Elite
//
//  Created by Leandro Wauters on 4/15/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

struct MessageCollectionKeys {
    static let collectionKey = "message"
    static let messageIdKey = "messageId"
    static let senderIdKey = "sender"
    static let recieverKey = "reciever"
    static let messageKey = "message"
}
class Message {
    let messageId: String
    let sender: String
    let reciever: String
    let message: String
    
    init(messageId: String, sender: String, reciever: String, message: String) {
        self.messageId = messageId
        self.sender = sender
        self.reciever = reciever
        self.message = message
    }
    init(dict: [String: Any]) {
        self.messageId = dict[MessageCollectionKeys.messageIdKey] as? String ?? "N/A"
        self.sender = dict[MessageCollectionKeys.senderIdKey] as? String ?? "N/A"
        self.reciever = dict[MessageCollectionKeys.recieverKey] as? String ?? "N/A"
        self.message = dict[MessageCollectionKeys.messageKey] as? String ?? "N/A"
    }
}
