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
        }
        if let blueOnePlayer = blueOnePlayer {
           bluePlayerOneLabel.text = blueOnePlayer.username
        }
        if let blueTwoPlayer = blueTwoPlayer {
           bluePlayerTwoLabel.text = blueTwoPlayer.username
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
      guard let redPlayerTwo = redTwoPlayer,
        let bluePlayerOne = blueOnePlayer,
        let bluePlayerTwo = blueTwoPlayer else {
            showAlert(title: "Please selecte every player", message: nil)
            return
        }

        let game = GameModel(gameName: gameName.rawValue, gameType: gameTypeSelected.rawValue, numberOfPlayers: 2, teamA: [TabBarViewController.currentUser.uid, redPlayerTwo.gamerID], teamB: [bluePlayerOne.gamerID, bluePlayerTwo.gamerID], parkId: "1", gameDescription: nil, gameEndTime: nil, winners: nil, losers: nil, isTie: nil, formattedAdresss: "2", parkName: "3", lat: 0.0, lon: 0.0, gameID: "", witness: nil, duration: nil, isOver: false)
        DBService.postGame(gamePost: game) { (error , gameId) in
            if let error = error {
                self.showAlert(title: "Error posting game", message: error.localizedDescription)
            }
            if let gameId = gameId {
                let currentPlayer = CurrentPlayer(currentPlayerId: "",gamerId: TabBarViewController.currentUser.uid, userName: TabBarViewController.currentUser.displayName ?? "N/A", teamRole: TeamRoles.blueOne.rawValue)
                DBService.postCurrentPlayer(currentPlayer: currentPlayer) { (error) in
                    if let error = error {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
                let redPlayerTwoInvitation = Invitation(invitationId: "", gameId: gameId, sender: TabBarViewController.currentUser.uid, reciever: redPlayerTwo.gamerID, message: "Invitation", approval: false, lat: 0, lon: 0, game: self.gameName.rawValue, senderUsername: TabBarViewController.currentUser.displayName ?? "", gameType: self.gameTypeSelected.rawValue)
                let bluePlayerOneInvitation = Invitation(invitationId: "", gameId: gameId, sender: TabBarViewController.currentUser.uid, reciever: bluePlayerOne.gamerID, message: "Invitation", approval: false, lat: 0, lon: 0, game: self.gameName.rawValue, senderUsername: TabBarViewController.currentUser.displayName ?? "", gameType: self.gameTypeSelected.rawValue)
                let bluePlayerTwoInviation = Invitation(invitationId: "", gameId: gameId, sender: TabBarViewController.currentUser.uid, reciever: bluePlayerTwo.gamerID, message: "Invitation", approval: false, lat: 0, lon: 0, game: self.gameName.rawValue, senderUsername: TabBarViewController.currentUser.displayName ?? "", gameType: self.gameTypeSelected.rawValue)
                let invitations = [redPlayerTwoInvitation, bluePlayerOneInvitation, bluePlayerTwoInviation]
                DBService.postMultipleInvitations(invitations: invitations, completion: { (error, invitationId) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    if let invitationId = invitationId {
                        DBService.fetchInvitation(inivtationId: invitationId, completion: { (error, invitation) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            if let invitation = invitation{
                                let currentGame = CurrentGame(currentGameId: "", gameId: gameId, redOne: TabBarViewController.currentUser.displayName!, redTwo: redPlayerTwo.username, redThree: nil, redFour: nil, redFive: nil, blueOne: bluePlayerOne.username, blueTwo: bluePlayerTwo.username, blueThree: nil, blueFour: nil, blueFive: nil)
                                DBService.postCurrentGame(currentGame: currentGame, completion: { (error) in
                                    self.showAlert(title: "Error posting current game", message: error?.localizedDescription)
                                })
                                let twoVsTwoProgressViewController = TwoVsTwoProgressViewController.init(nibName: "TwoVsTwoProgressViewController", bundle: nil)
                                twoVsTwoProgressViewController .modalPresentationStyle = .fullScreen
                                twoVsTwoProgressViewController.invitation = invitation
                                twoVsTwoProgressViewController.isHost = true
                                twoVsTwoProgressViewController.game = game
                                twoVsTwoProgressViewController.redPlayerOne = TabBarViewController.currentUser.displayName!
                                twoVsTwoProgressViewController.redPlayerTwo = self.redTwoPlayer
                                twoVsTwoProgressViewController.bluePlayerOne = self.blueOnePlayer
                                twoVsTwoProgressViewController.bluePlayerTwo = self.blueTwoPlayer
                                twoVsTwoProgressViewController.gameType = .twoVsTwo
                                self.present(twoVsTwoProgressViewController , animated: true)
                                
                            }
                        })
                    }
                    
                })
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
