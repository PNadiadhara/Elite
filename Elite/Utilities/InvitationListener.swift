//
//  InvitationListener.swift
//  Elite
//
//  Created by Leandro Wauters on 4/17/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import Firebase

class InvitationListener {
    static func fetchForInvitationRequest(vc: UIViewController) {
        guard let user = AppDelegate.authservice.getCurrentUser() else {return}
        var listener: ListenerRegistration!
        listener = DBService.firestoreDB.collection(InvitationCollectionKeys.collectionKey).whereField("reciever", isEqualTo: user.uid)
            .addSnapshotListener {(snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let snapshot = snapshot {
                    let invitations = snapshot.documents.map {Invitation.init(dict: $0.data())}
                    if invitations.count > 0 {
                        let invitationAlertVC = InvitationAlertViewController.init(nibName: "InvitationAlertViewController", bundle: nil)
                        invitationAlertVC.invitation = invitations.first
                        invitationAlertVC.modalPresentationStyle = .overCurrentContext
                        
                        vc.present(invitationAlertVC, animated: true)
                        
                    }
                }
        }
    }
}
