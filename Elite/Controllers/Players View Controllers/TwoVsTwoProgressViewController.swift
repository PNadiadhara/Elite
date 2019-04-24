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
        redPlayerOneLabel.text = redPlayerOne
        redPlayerTwoLabel.text = redPlayerTwo.username
        bluePlayerOneLabel.text = bluePlayerOne.username
        bluePlayerTwoLabel.text = bluePlayerTwo.username
        
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
                    self.present(endGameVc, animated: true)
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
