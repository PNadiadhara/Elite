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
                      InvitationCollectionKeys.recieverKey : invitation.reciever, InvitationCollectionKeys.messageKey : invitation.message, InvitationCollectionKeys.approvalKey : invitation.approval]) { (error) in
                        if let error = error {
                            completion(error,nil)
                        } else {
                            completion(nil, ref.documentID)
                        }
        }
        
        
}
    static public func updateInvitationApprovalToTrue(invitation: Invitation,completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB.collection(InvitationCollectionKeys.collectionKey).document(String(invitation.invitationId)).updateData([InvitationCollectionKeys.approvalKey : true ]) { (error) in
            if let error = error {
                completion(error)
            }
            }
        }
    static public func deleteInvitation(invitation: Invitation, completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB
            .collection(InvitationCollectionKeys.collectionKey)
            .document(String(invitation.invitationId))
            .delete { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
}
