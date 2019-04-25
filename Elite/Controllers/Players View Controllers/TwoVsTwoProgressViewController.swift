//
//  TwoVsTwoProgressViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 4/23/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class TwoVsTwoProgressViewController: UIViewController {
    @IBOutlet weak var redPlayerOneImage: CircularRedImageView!
    @IBOutlet weak var bluePlayerOneImage: CircularBlueImageView!
    @IBOutlet weak var bluePlayerTwoImage: CircularBlueImageView!
    @IBOutlet weak var redPlayerTwoImage: CircularRedImageView!
    @IBOutlet weak var redPlayerOneLabel: UILabel!
    
    @IBOutlet weak var redPlayerTwoLabel: UILabel!
    
    @IBOutlet weak var bluePlayerOneLabel: UILabel!
    @IBOutlet weak var bluePlayerTwoLabel: UILabel!
    @IBOutlet weak var sportSelectedLabel: UILabel!
    
    @IBOutlet weak var parkSelectedLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var waitingScreen: UIView!
    @IBOutlet weak var cancelButton: RoundedButton!
    @IBOutlet weak var endButton: RoundedButton!

    
    
    
    var buttons = [UIButton]()
    var invitation: Invitation?
    var invitations = [Invitation]()
    var postedInvitations = [Invitation]()
    var isHost = Bool()
    var currentPlayer: CurrentPlayer?
    var currentPlayerTeamRole = String()
    var game: GameModel?
    var gameType: GameType!
    var redPlayerOne = String()
    var redPlayerTwo: GamerModel!
    var bluePlayerOne: GamerModel!
    var bluePlayerTwo: GamerModel!
    private var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [cancelButton, endButton]
        fetchInvitationApproval()
        setupLabels()
        if !isHost{
            buttons.forEach{$0.isHidden = true}
            fetchForGameCreated()
        }
        fetchPostedInvitation()
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
    }
    @IBAction func cancelWaiting(_ sender: UIButton) {
        DBService.deleteMultipleInvitations(invitations: postedInvitations) { (error) in
            if let error = error {
                print(error)
            } else {
                self.dismiss(animated: true)
                print("Invitations deleted")
            }
        }
    }
    func fetchPostedInvitation(){
        guard let invitation = invitation else {
            print("No Invitation")
            return
        }
        DBService.fetchGameInvitations(gameId: invitation.gameId) { (error, invitations) in
            if let error = error {
                print(error)
            }
            if let invitations = invitations {
                self.postedInvitations = invitations
            }
        }
    }
    func setupLabels(){
        guard let invitation = invitation else {
            print("No Invitation")
            return
        }
        DBService.fetchCurrentGame(gameId: invitation.gameId) { (error, currentGame) in
            if let error = error {
                self.showAlert(title: "Error Fetching game", message: error.localizedDescription)
            }
            if let currentGame = currentGame {
                guard let redOne = currentGame.redOne,
                    let redTwo = currentGame.redTwo,
                    let blueOne = currentGame.blueOne,
                    let blueTwo = currentGame.blueTwo else {
                        print("Error fetching current game")
                        return
                }
                self.redPlayerOneLabel.text = redOne
                self.redPlayerTwoLabel.text = redTwo
                self.bluePlayerTwoLabel.text = blueTwo
                self.bluePlayerOneLabel.text = blueOne
            }
        }
    }
    
    @objc func fetchInvitationApproval() {
        guard let invitation = invitation else {return}
        listener = DBService.firestoreDB.collection(InvitationCollectionKeys.collectionKey).whereField(InvitationCollectionKeys.approvalKey, isEqualTo: true).whereField(InvitationCollectionKeys.gameIdKey, isEqualTo: invitation.gameId).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot {
                self.invitations = snapshot.documents.map {Invitation.init(dict: $0.data())}
                if self.invitations.count > 2{
                    self.waitingScreen.isHidden = true
                    self.endButton.isEnabled = true
                    self.cancelButton.isEnabled = true
                    DBService.deleteInvitation(invitation: self.invitation!, completion: { (error) in
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
                    endGameVc.gameType = self.gameType
                    self.present(endGameVc, animated: true)
                }
            }
        }
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
    }
    @IBAction func endPressed(_ sender: Any) {
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
        endGameVc.gameType = gameType
        present(endGameVc, animated: true)
    }
    
    
    
    
}
