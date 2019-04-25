//
//  OneVsOneViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import FirebaseFirestore
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
    @IBOutlet weak var bluePlayerImage: UIImageView!
    @IBOutlet weak var redPlayerImage: UIImageView!
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
    var gameName: GameName!
    var gameTypeSelected: GameType!
    //TO DO: Create a park
    var selectedInvitationOption: SelectedInvitationOption = .accepted
    
    private var listener: ListenerRegistration!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupTap()
        sportLabel.text = gameName.rawValue.capitalized
        redPlayerLabel.text = TabBarViewController.currentUser.displayName
        redPlayerImage.image = UIImage(named: TabBarViewController.currentUser.displayName! + "FightingLeft")
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if let gamer = gamerSelected {
            bluePlayerLabel.text = gamer.username
            bluePlayerImage.image = UIImage(named: gamer.username + "FightingRight")
        }
    }
    

    @IBAction func playButtonPressed(_ sender: UIButton) {
        guard let gamerSelected = gamerSelected else {
            showAlert(title: "Please select player", message: nil)
            return
        }
        //To do: CREATE INSTANSE OF GAME

        let game = GameModel(gameName: gameName.rawValue, gameType: gameTypeSelected.rawValue, numberOfPlayers: 2, teamA: [TabBarViewController.currentUser.uid], teamB: [gamerSelected.gamerID], parkId: "1", gameDescription: nil, gameEndTime: nil, winners: nil, losers: nil, isTie: nil, formattedAdresss: "2", parkName: "3", lat: 0.0, lon: 0.0, gameID: "", witness: nil, duration: nil, isOver: false)
        DBService.postGame(gamePost: game) { (error, gameId) in
            if let error = error {
                self.showAlert(title: "Error posting game", message: error.localizedDescription)
            }
            if let gameId = gameId {
                let currentPlayer = CurrentPlayer(currentPlayerId: "",gamerId: TabBarViewController.currentUser.uid, userName: TabBarViewController.currentUser.displayName ?? "N/A", teamRole: TeamRoles.redOne.rawValue)
                DBService.postCurrentPlayer(currentPlayer: currentPlayer) { (error) in
                    if let error = error {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
                let invitation = Invitation(invitationId: "", gameId: gameId ,sender: TabBarViewController.currentUser.uid, reciever: gamerSelected.gamerID, message: "Invitation", approval: false, lat: 0.0, lon: 0.0, game: self.gameName.rawValue, senderUsername: TabBarViewController.currentUser.displayName ?? "", gameType: self.gameTypeSelected.rawValue)
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
                                oneVsoneProgressVc.gameType = .oneVsOne
                                oneVsoneProgressVc.game = game
                                self.present(oneVsoneProgressVc, animated: true)
                            }
                        })
                        
                    }
                }
            }
        }

//        DBService.postInvitation(invitation: invitation) { (error ) in
//            print("Error posting message")
//        }


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
        searchPlayerVc.teamRole = .blueOne
        searchPlayerVc.gameType = .oneVsOne
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


