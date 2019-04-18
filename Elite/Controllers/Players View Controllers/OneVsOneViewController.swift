//
//  OneVsOneViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Firebase
protocol SearchForPlayerDelegate: AnyObject {
    func gamerSelected(gamer: GamerModel)
}
enum SelectedInvitationOption {
    case accepted
    case declined
}
class OneVsOneViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchPlayerView: versusLeft!
    @IBOutlet weak var bluePlayerImage: CircularBlueImageView!
    @IBOutlet weak var redPlayerImage: CircularRedImageView!
    @IBOutlet weak var redPlayerLabel: UILabel!
    @IBOutlet weak var bluePlayerLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addPlayerView: UIView!
    @IBOutlet weak var redPlayerRanking: UILabel!
    @IBOutlet weak var redPlayerMedalImage: UIImageView!
    @IBOutlet weak var bluePlayerRanking: UILabel!
    @IBOutlet weak var bluePlayerMedal: UIImageView!
    
    var gamerSelected: GamerModel?
    var invitation: Invitation?
    var invitations = [Invitation]()
    var user: User!
    var gameSelected: Game!
    var selectedInvitationOption: SelectedInvitationOption = .accepted
    
    private var listener: ListenerRegistration!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = AppDelegate.authservice.getCurrentUser() else {return}
        self.user = user
        setupTap()
        sportLabel.text = gameSelected.rawValue.capitalized
        redPlayerLabel.text = user.displayName
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if let gamer = gamerSelected {
            bluePlayerLabel.text = gamer.username
        }
    }
    

    @IBAction func playButtonPressed(_ sender: UIButton) {
        guard let gamerSelected = gamerSelected else {
            showAlert(title: "Please select player", message: nil)
            return
        }
        //To do: CREATE INSTANSE OF GAME
//        let invitation = Invitation(invitationId: "", sender: user.uid, reciever: gamerSelected.gamerID, message: "Invitation", approval: false)
        let invitation = Invitation(invitationId: "", sender: user.uid, reciever: gamerSelected.gamerID, message: "Invitation", approval: false, lat: 0.0, lon: 0.0, game: gameSelected.rawValue, senderUsername: user.displayName ?? "")
//        DBService.postInvitation(invitation: invitation) { (error ) in
//            print("Error posting message")
//        }
        DBService.postInvitation(invitation: invitation) { (error, invitationId) in
            if let error = error {
                self.showAlert(title: "Error posting invitation", message: error.localizedDescription)
            }
            if let invitationId = invitationId{
                DBService.fetchInvitation(inivtationId: invitationId, completion: { (error, invitation) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    if let invitation = invitation {
                        let oneVsoneProgressVc = OneVsOneProgressViewController.init(nibName: "OneVsOneProgressViewController", bundle: nil)
                        oneVsoneProgressVc.modalPresentationStyle = .fullScreen
                        oneVsoneProgressVc.invitation = invitation
                        oneVsoneProgressVc.isHost = true
                        self.present(oneVsoneProgressVc, animated: true)
                    }
                })

            }
        }

    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func setupTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchPlayerPressed))
        addPlayerView.addGestureRecognizer(tap)
    }

//    @objc func fetchInvitationRequest() {
//        listener = DBService.firestoreDB.collection(InvitationCollectionKeys.collectionKey).whereField("reciever", isEqualTo: user.uid)
//            .addSnapshotListener { [weak self] (snapshot, error) in
//                if let error = error {
//                    self?.showAlert(title: "Error fetching blogs", message: error.localizedDescription)
//                } else if let snapshot = snapshot {
//                    print("Invitation recieved")
//                    self?.invitations = snapshot.documents.map {Invitation.init(dict: $0.data())}
//                    if (self?.invitations.count)! > 0 {
//                        self?.presentAlertVC()
//                    }
//                }
//        }
//    }
    @objc func searchPlayerPressed() {
        let searchPlayerVc = SearchPlayerViewController.init(nibName: "SearchPlayerViewController", bundle: nil)
        searchPlayerVc.modalPresentationStyle = .fullScreen
        searchPlayerVc.searchDelegate = self
        present(searchPlayerVc, animated: true)
        
    }
//    func presentAlertVC() {
//        let invitationAlertVC = InvitationAlertViewController.init(nibName: "InvitationAlertViewController", bundle: nil)
//        invitationAlertVC.invitation = invitations.first
//        invitationAlertVC.modalPresentationStyle = .overCurrentContext
//
//        present(invitationAlertVC, animated: true)
//    }
}

extension OneVsOneViewController: SearchForPlayerDelegate{
    func gamerSelected(gamer: GamerModel) {
        self.gamerSelected = gamer
    }
    
    
}


