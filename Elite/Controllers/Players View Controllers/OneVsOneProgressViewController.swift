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

//class OneVsOneProgressViewController: UIViewController {
//
//    var buttons = [UIButton]()
//    var invitation: Invitation?
//    var invitations = [Invitation]()
//    var isHost = Bool()
//    var game: GameModel?
//    var blueOnePlayer: GamerModel!
//    var redOnePlayer: GamerModel!
//    var gameType: GameType!
//    var gameBeginingTimeStamp = Date()
//    var parkSelected = String()
//    private var listener: ListenerRegistration!
//    
//    @IBOutlet weak var sportParkLabel: UILabel!
//    @IBOutlet weak var redTeamImage: UIImageView!
//    @IBOutlet weak var redTeamLabel: UILabel!
//    @IBOutlet weak var blueTeamImage: UIImageView!
//    @IBOutlet weak var blueTeamLabel: UILabel!
//    @IBOutlet weak var cancelButton: RoundedButton!
//    @IBOutlet weak var endButton: RoundedButton!
//    @IBOutlet weak var waitingScreen: UIView!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var headerView: UIView!
//    @IBOutlet weak var cancelGameButton: UIButton!
//    @IBOutlet weak var gameInProgressLabel: UILabel!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUpUI()
//        buttons = [cancelButton, endButton]
//        if isHost {
//            fetchInvitationApproval()
//        } else {
//            buttons.forEach{$0.isHidden = true}
//            waitingScreen.isHidden = true
//            fetchForGameCreated()
//            
//        }
//        fetchForGameCanceled()
//        
//    }
//
//    func setUpUI() {
//        gameInProgressLabel.text = "Game in progress.."
//        redTeamLabel.text = redOnePlayer.username
//        redTeamImage.image = UIImage(named: redOnePlayer.username + "FightingLeft")
//        blueTeamLabel.text = blueOnePlayer.username
//        blueTeamImage.image = UIImage(named: blueOnePlayer.username + "FightingRight")
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        listener.remove()
//    }
// 
//    func fetchInvitationApproval() {
//        guard let invitation = invitation else {return}
//        listener = DBService.firestoreDB.collection(InvitationCollectionKeys.collectionKey).whereField(InvitationCollectionKeys.approvalKey, isEqualTo: true).whereField(InvitationCollectionKeys.invitationIdKey, isEqualTo: invitation.invitationId).addSnapshotListener({[weak self] (snapshot, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else if let snapshot = snapshot {
//                self?.invitations = snapshot.documents.map {Invitation.init(dict: $0.data())}
//                if (self?.invitations.count)! > 0 {
//                    if self?.isHost ?? true {
//                      self?.gameBeginingTimeStamp = Date()
//                    }
//                    self?.waitingScreen.isHidden = true
//                    self?.endButton.isEnabled = true
//                    self?.cancelButton.isEnabled = true
//                    DBService.deleteInvitation(invitation: (self?.invitation!)!, completion: { (error) in
//                        if let error = error {
//                            print(error.localizedDescription)
//                        }
//                    })
//                }
//            }
//        })
//    }
//    func fetchForGameCanceled() {
//        guard let invitation = invitation else {
//            print("No Invitation")
//            return
//        }
//        listener = DBService.firestoreDB.collection(GameCollectionKeys.CollectionKey).whereField(GameCollectionKeys.wasCancelledKey, isEqualTo: true).whereField(GameCollectionKeys.GameIDKey, isEqualTo: invitation.gameId).addSnapshotListener { (snapshot, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            if let snapshot = snapshot {
//                let games = snapshot.documents.map {GameModel.init(dict: $0.data())}
//                if games.count > 0 {
//                    self.showAlert(title: "Host ended game", message: "Press okay to continue", handler: { (alert) in
//                        let tab = TabBarViewController.setTabBarVC()
//                        self.present(tab, animated: true)
//                    })
//                }
//            }
//        }
//    }
//    func fetchForGameCreated() {
//        guard let invitation = invitation else {
//            print("No Invitation")
//            return
//        }
//        listener = DBService.firestoreDB.collection(GameCollectionKeys.CollectionKey).whereField(GameCollectionKeys.isOverKey, isEqualTo: true).whereField(GameCollectionKeys.GameIDKey, isEqualTo: invitation.gameId).addSnapshotListener { (snapshot, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            if let snapshot = snapshot {
//                let games = snapshot.documents.map {GameModel.init(dict: $0.data())}
//                if games.count > 0 {
//                    let endGameVc = EndGameViewController.init(nibName: "EndGameViewController", bundle: nil)
////                    endGameVc.modalPresentationStyle = .overCurrentContext
////                    endGameVc.invitation = invitation
////                    endGameVc.isHost = false
////                    endGameVc.gameType = self.gameType
////                    endGameVc.blueOnePlayer = self.blueOnePlayer
////                    endGameVc.redOnePlayer = self.redOnePlayer
//                    self.present(endGameVc, animated: true)
//                }
//            }
//        }
//    }
//    @IBAction func cancelGamePressed(_ sender: UIButton) {
//        guard let invitation = invitation else {return}
//        waitingScreen.isHidden = true
//        DBService.deleteInvitation(invitation: invitation) { (error) in
//            if let error = error {
//                print(error)
//            }
//        }
//        DBService.deleteGamePost(gameId: invitation.gameId, completion: { (error) in
//            if let error = error {
//                print(error)
//            }
//        })
//        
//        DBService.fetchCurrentPlayer(gamerId: TabBarViewController.currentGamer.gamerID , completion: { (error, currentPlayer) in
//            if let error = error {
//                print(error)
//            }
//            if let currentPlayer = currentPlayer {
//                DBService.deleteCurrentPlayer(currentPlayer: currentPlayer, completion: { (error) in
//                    if let error = error {
//                        print(error)
//                    }
//                })
//            }
//        })
//        dismiss(animated: true)
//    }
//    
//    
//    @IBAction func cancelPressed(_ sender: UIButton) {
//        confirmAlert(title: "Cancel Game", message: "Are you sure?") { (action) in
//            guard let invitation = self.invitation else {return}
//            DBService.updateGameToCancelled(gameId: invitation.gameId)
//            DBService.deleteInvitation(invitation: invitation) { (error) in
//                if let error = error {
//                    print(error)
//                }
//            }
//            DBService.deleteGamePost(gameId: invitation.gameId, completion: { (error) in
//                if let error = error {
//                    print(error)
//                }
//            })
//            
//            DBService.fetchCurrentPlayer(gamerId: TabBarViewController.currentGamer.gamerID , completion: { (error, currentPlayer) in
//                if let error = error {
//                    print(error)
//                }
//                if let currentPlayer = currentPlayer {
//                    DBService.deleteCurrentPlayer(currentPlayer: currentPlayer, completion: { (error) in
//                        if let error = error {
//                            print(error)
//                        }
//                    })
//                }
//            })
//            
//            let tab = TabBarViewController.setTabBarVC()
//            self.present(tab, animated: true)
//        }
//    }
//    @IBAction func endPressed(_ sender: UIButton) {
//        let endGameVc = EndGameViewController.init(nibName: "EndGameViewController", bundle: nil)
//        guard let invitation = invitation else {
//            print("No Invite")
//            return
//        }
//        DBService.updateGameToFinish(gameId: invitation.gameId)
//        endGameVc.modalPresentationStyle = .overCurrentContext
////        endGameVc.game = game
//        endGameVc.invitation = invitation
//        endGameVc.isHost = true
//        if isHost {
//            endGameVc.gameBegginingTimeStamp = gameBeginingTimeStamp
//            endGameVc.gameEndTimeStamp = Date()
//        }
//        endGameVc.gameType = gameType
//        endGameVc.blueOnePlayer = blueOnePlayer
//        endGameVc.redOnePlayer = redOnePlayer
//        present(endGameVc, animated: true)
//    }
//    
//
//}




    

