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
    static let senderIdKey = "sender"
    static let recieverKey = "reciever"
    static let messageKey = "message"
    static let approvalKey = "approval"
}
class Invitation {
    let invitationId: String
    let sender: String
    let reciever: String
    let message: String
    let approval: Bool
    
    init(invitationId: String, sender: String, reciever: String, message: String, approval: Bool) {
        self.invitationId = invitationId
        self.sender = sender
        self.reciever = reciever
        self.message = message
        self.approval = approval
    }
    init(dict: [String: Any]) {
        self.invitationId = dict[InvitationCollectionKeys.invitationIdKey] as? String ?? "N/A"
        self.sender = dict[InvitationCollectionKeys.senderIdKey] as? String ?? "N/A"
        self.reciever = dict[InvitationCollectionKeys.recieverKey] as? String ?? "N/A"
        self.message = dict[InvitationCollectionKeys.messageKey] as? String ?? "N/A"
        self.approval = dict[InvitationCollectionKeys.approvalKey] as? Bool ?? false
    }
}
