//
//  OneVsOneProggressViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 4/13/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class OneVsOneProgressViewController: UIViewController {

    var buttons = [UIButton]()
    var invitation: Invitation?
    var invitations = [Invitation]()
    var isHost = Bool()
    var game: GameModel?
    private var listener: ListenerRegistration!
    
    @IBOutlet weak var sportParkLabel: UILabel!
    @IBOutlet weak var redTeamImage: CircularRedImageView!
    @IBOutlet weak var redTeamLabel: UILabel!
    @IBOutlet weak var blueTeamImage: CircularBlueImageView!
    @IBOutlet weak var blueTeamLabel: UILabel!
    @IBOutlet weak var cancelButton: RoundedButton!
    @IBOutlet weak var endButton: RoundedButton!
    @IBOutlet weak var waitingScreen: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cancelGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [cancelButton, endButton]
        if isHost {
            fetchInvitationApproval()
        } else {
            buttons.forEach{$0.isHidden = true}
            waitingScreen.isHidden = true
            fetchForGameCreated()
            
        }
        
    }


    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
    }
 
    func fetchInvitationApproval() {
        guard let invitation = invitation else {return}
        listener = DBService.firestoreDB.collection(InvitationCollectionKeys.collectionKey).whereField(InvitationCollectionKeys.approvalKey, isEqualTo: true).whereField(InvitationCollectionKeys.invitationIdKey, isEqualTo: invitation.invitationId).addSnapshotListener({[weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot {
                self?.invitations = snapshot.documents.map {Invitation.init(dict: $0.data())}
                if (self?.invitations.count)! > 0 {
                    self?.waitingScreen.isHidden = true
                    self?.endButton.isEnabled = true
                    self?.cancelButton.isEnabled = true
                    DBService.deleteInvitation(invitation: (self?.invitation!)!, completion: { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    })
                }
            }
        })
    }

    func fetchForGameCreated() {
        guard let invitation = invitation else {
            print("No Invitation")
            return
        }
        listener = DBService.firestoreDB.collection(GameCollectionKeys.CollectionKey).whereField(GameCollectionKeys.isOverKey, isEqualTo: true).whereField(GameCollectionKeys.GameIDKey, isEqualTo: invitation.gameId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                let games = snapshot.documents.map {GameModel.init(dict: $0.data())}
                if games.count > 0 {
                    let endGameVc = EndGameViewController.init(nibName: "EndGameViewController", bundle: nil)
                    endGameVc.modalPresentationStyle = .overCurrentContext
                    endGameVc.invitation = invitation
                    endGameVc.isHost = false
                    self.present(endGameVc, animated: true)
                }
            }
        }
    }
    @IBAction func cancelGamePressed(_ sender: UIButton) {
        guard let invitation = invitation else {return}
        waitingScreen.isHidden = true
        DBService.deleteInvitation(invitation: invitation) { (error) in
            if let error = error {
                print(error)
            }
        }
        dismiss(animated: true)
    }
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        confirmAlert(title: "Game Cancel", message: "Are you sure?") { (action) in
            guard let invitation = self.invitation else {return}
            DBService.deleteInvitation(invitation: invitation) { (error) in
                if let error = error {
                    print(error)
                }
            }
            let tab = TabBarViewController.setTabBarVC()
            self.present(tab, animated: true)
        }
    }
    @IBAction func endPressed(_ sender: UIButton) {
        let endGameVc = EndGameViewController.init(nibName: "EndGameViewController", bundle: nil)
        guard let invitation = invitation else {
            print("No Invite")
            return
        }
        DBService.updateGameToFinish(gameId: invitation.gameId)
        endGameVc.modalPresentationStyle = .overCurrentContext
        
//        endGameVc.game = game
        endGameVc.invitation = invitation
        endGameVc.isHost = true
        present(endGameVc, animated: true)
    }
    

}
