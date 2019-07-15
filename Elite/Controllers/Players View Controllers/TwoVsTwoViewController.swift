//
//  TwoVsTwoViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

protocol twoVsTwoSearchDelegate: AnyObject {
    func redTwoPlayer(redTwoPlayer: GamerModel?)
    func blueOnePlayer(blueOnePlayer: GamerModel?)
    func blueTwoPlayer(blueTwoPlayer: GamerModel?)
}
class TwoVsTwoViewController: UIViewController {

    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var redPlayerOneImage: UIImageView!
    @IBOutlet weak var redPlayerOneLabel: UILabel!
    @IBOutlet weak var redPlayerTwoImage: UIImageView!
    @IBOutlet weak var redPlayerTwoLabel: UILabel!
    @IBOutlet weak var bluePlayerOneImage: UIImageView!
    @IBOutlet weak var bluePlayerOneLabel: UILabel!
    @IBOutlet weak var bluePlayerTwoImage: UIImageView!
    @IBOutlet weak var bluePlayerTwoLabel: UILabel!
    @IBOutlet weak var redPlayerTwoButton: UIButton!
    @IBOutlet weak var bluePlayerOneButton: UIButton!
    @IBOutlet weak var bluePlayerTwoButton: UIButton!
    
    
    
    
    
    var redTwoPlayer: GamerModel?
    var blueOnePlayer: GamerModel?
    var blueTwoPlayer: GamerModel?
    var gameName: GameName!
    var gameTypeSelected: GameType!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupUI() {
        sportLabel.text = gameName.rawValue.capitalized
        redPlayerOneImage.image = UIImage(named: TabBarViewController.currentUser.displayName! + "FightingLeft")
        redPlayerOneLabel.text = TabBarViewController.currentUser.displayName
        if let redTwoPlayer = redTwoPlayer{
            redPlayerTwoLabel.text = redTwoPlayer.username
            redPlayerTwoImage.image = UIImage(named: redTwoPlayer.username! + "FightingRight")
        }
        if let blueOnePlayer = blueOnePlayer {
           bluePlayerOneLabel.text = blueOnePlayer.username
            bluePlayerOneImage.image = UIImage(named: blueOnePlayer.username! + "FightingLeft")
        }
        if let blueTwoPlayer = blueTwoPlayer {
           bluePlayerTwoLabel.text = blueTwoPlayer.username
            bluePlayerTwoImage.image = UIImage(named: blueTwoPlayer.username! + "FightingRight")
        }
        
    }
    @IBAction func addPlayerPressed(_ sender: UIButton) {
        let searchPlayerVc = SearchPlayerViewController.init(nibName: "SearchPlayerViewController", bundle: nil)
        searchPlayerVc.modalPresentationStyle = .fullScreen
        searchPlayerVc.twoVsTwoSearchDelegate = self
        searchPlayerVc.gameType = .twoVsTwo
        switch sender.tag {
        case 0:
            searchPlayerVc.teamRole = .redTwo
        case 1:
            searchPlayerVc.teamRole = .blueOne
        case 2:
            searchPlayerVc.teamRole = .blueTwo
            
        default:
            return
            
        }
        
        present(searchPlayerVc, animated: true)
        
    }
    @IBAction func playPressed(_ sender: UIButton) {
        guard let _ = redTwoPlayer,
            let _ = blueOnePlayer,
            let _ = blueTwoPlayer else {
            showAlert(title: "Please select every player", message: nil)
            return
        }


        
//        DBService.postGame(gamePost: game) { (error , gameId) in
//            if let error = error {
//                self.showAlert(title: "Error posting game", message: error.localizedDescription)
//            }
//            if let gameId = gameId {
//                
//                self.setupCurrentGame(gameId: gameId)
//                let redPlayerTwoInvitation = Invitation(invitationId: "", gameId: gameId, sender: TabBarViewController.currentUser.uid, reciever: redPlayerTwo.gamerID, message: "Invitation", approval: false, lat: 0, lon: 0, game: self.gameName.rawValue, senderUsername: TabBarViewController.currentUser.displayName ?? "", gameType: self.gameTypeSelected.rawValue)
//                let bluePlayerOneInvitation = Invitation(invitationId: "", gameId: gameId, sender: TabBarViewController.currentUser.uid, reciever: bluePlayerOne.gamerID, message: "Invitation", approval: false, lat: 0, lon: 0, game: self.gameName.rawValue, senderUsername: TabBarViewController.currentUser.displayName ?? "", gameType: self.gameTypeSelected.rawValue)
//                let bluePlayerTwoInviation = Invitation(invitationId: "", gameId: gameId, sender: TabBarViewController.currentUser.uid, reciever: bluePlayerTwo.gamerID, message: "Invitation", approval: false, lat: 0, lon: 0, game: self.gameName.rawValue, senderUsername: TabBarViewController.currentUser.displayName ?? "", gameType: self.gameTypeSelected.rawValue)
//                let invitations = [redPlayerTwoInvitation, bluePlayerOneInvitation, bluePlayerTwoInviation]
//                DBService.postMultipleInvitations(invitations: invitations, completion: { (error, invitationId) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                    }
//                    if let invitationId = invitationId {
//                        DBService.fetchInvitation(inivtationId: invitationId, completion: { (error, invitation) in
//                            if let error = error {
//                                print(error.localizedDescription)
//                            }
//                            if let invitation = invitation{
//                                let currentGame = CurrentGame(currentGameId: "", gameId: gameId, redOne: TabBarViewController.currentUser.displayName!, redTwo: redPlayerTwo.username, redThree: nil, redFour: nil, redFive: nil, blueOne: bluePlayerOne.username, blueTwo: bluePlayerTwo.username, blueThree: nil, blueFour: nil, blueFive: nil)
//                                DBService.postCurrentGame(currentGame: currentGame, completion: { (error) in
//                                    self.showAlert(title: "Error posting current game", message: error?.localizedDescription)
//                                })
//                                let twoVsTwoProgressViewController = TwoVsTwoProgressViewController.init(nibName: "TwoVsTwoProgressViewController", bundle: nil)
//                                twoVsTwoProgressViewController .modalPresentationStyle = .fullScreen
//                                twoVsTwoProgressViewController.invitation = invitation
//                                twoVsTwoProgressViewController.isHost = true
//                                twoVsTwoProgressViewController.game = game
//                                twoVsTwoProgressViewController.redPlayerOne = TabBarViewController.currentUser.displayName!
//                                twoVsTwoProgressViewController.redPlayerTwo = self.redTwoPlayer
//                                twoVsTwoProgressViewController.bluePlayerOne = self.blueOnePlayer
//                                twoVsTwoProgressViewController.bluePlayerTwo = self.blueTwoPlayer
//                                twoVsTwoProgressViewController.gameType = .twoVsTwo
//                                self.present(twoVsTwoProgressViewController , animated: true)
//                                
//                            }
//                        })
//                    }
//                    
//                })
//            }
//        }
    }
    func setupCurrentGame(gameId: String) {
        let redPlayerOne = CurrentPlayer(currentPlayerId: "",gamerId: TabBarViewController.currentUser.uid, userName: TabBarViewController.currentUser.displayName ?? "N/A", teamRole: TeamRoles.redOne.rawValue, gameId: gameId)
        let redPlayerTwo = CurrentPlayer(currentPlayerId: "", gamerId: redTwoPlayer!.gamerID, userName: redTwoPlayer!.username!, teamRole: TeamRoles.redTwo.rawValue, gameId: gameId)
        let bluePlayerOne = CurrentPlayer(currentPlayerId: "", gamerId: blueOnePlayer!.gamerID, userName: blueOnePlayer!.username!, teamRole: TeamRoles.blueOne.rawValue, gameId: gameId)
        let bluePlayerTwo = CurrentPlayer(currentPlayerId: "", gamerId: blueTwoPlayer!.gamerID, userName: blueTwoPlayer!.username!, teamRole: TeamRoles.blueTwo.rawValue, gameId: gameId)
        DBService.postCurrentPlayer(currentPlayer: redPlayerTwo) { (error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        DBService.postCurrentPlayer(currentPlayer: redPlayerOne) { (error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        DBService.postCurrentPlayer(currentPlayer: bluePlayerOne) { (error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        DBService.postCurrentPlayer(currentPlayer: bluePlayerTwo) { (error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension TwoVsTwoViewController: twoVsTwoSearchDelegate {
    func redTwoPlayer(redTwoPlayer: GamerModel?) {
        self.redTwoPlayer = redTwoPlayer
    }
    
    func blueOnePlayer(blueOnePlayer: GamerModel?) {
        self.blueOnePlayer = blueOnePlayer
        
    }
    
    func blueTwoPlayer(blueTwoPlayer: GamerModel?) {
        self.blueTwoPlayer = blueTwoPlayer
    }
    
    
}
