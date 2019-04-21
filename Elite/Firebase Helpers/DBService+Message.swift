//
//  DBService+Message.swift
//  Elite
//
//  Created by Leandro Wauters on 4/15/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

extension DBService {
    static public func postInvitation(invitation: Invitation, completion: @escaping (Error?, String?) -> Void)  {
        let ref = firestoreDB.collection(InvitationCollectionKeys.collectionKey).document()
        
        DBService.firestoreDB
            .collection(InvitationCollectionKeys.collectionKey)
            .document(ref.documentID)
            .setData([InvitationCollectionKeys.invitationIdKey : ref.documentID,
                      InvitationCollectionKeys.senderIdKey : invitation.sender,
                      InvitationCollectionKeys.recieverKey : invitation.reciever, InvitationCollectionKeys.messageKey : invitation.message, InvitationCollectionKeys.approvalKey : invitation.approval,InvitationCollectionKeys.latKey: invitation.lat,
                      InvitationCollectionKeys.lonKey : invitation.lon, InvitationCollectionKeys.gameKey : invitation.game, InvitationCollectionKeys.senderUsernameKey : invitation.senderUsername, InvitationCollectionKeys.gameIdKey : invitation.gameId]) { (error) in
                        if let error = error {
                            completion(error,nil)
                        } else {
                            completion(nil, ref.documentID)
                        }
        }
        
        
}
    static public func updateInvitationApprovalToTrue(invitation: Invitation,completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB.collection(InvitationCollectionKeys.collectionKey).document(invitation.invitationId).updateData([InvitationCollectionKeys.approvalKey : true ]) { (error) in
            if let error = error {
                completion(error)
                }
            }
        }
    static public func deleteInvitation(invitation: Invitation, completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB
            .collection(InvitationCollectionKeys.collectionKey)
            .document(invitation.invitationId)
            .delete { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
    static public func fetchInvitation(inivtationId: String, completion: @escaping (Error?, Invitation?) -> Void) {
       let query = firestoreDB.collection(InvitationCollectionKeys.collectionKey).whereField(InvitationCollectionKeys.invitationIdKey, isEqualTo: inivtationId)
        query.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(error,nil)
            }
            var invitations = [Invitation]()
            if let snapshot = snapshot {
                invitations = snapshot.documents.map {Invitation.init(dict: $0.data())}
                completion(nil, invitations.first)
            }
        }
    }
}
