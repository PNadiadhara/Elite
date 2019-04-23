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
    @IBOutlet weak var redPlayerOneImage: CircularRedImageView!
    @IBOutlet weak var redPlayerOneLabel: UILabel!
    @IBOutlet weak var redPlayerTwoImage: CircularRedImageView!
    @IBOutlet weak var redPlayerTwoLabel: UILabel!
    @IBOutlet weak var bluePlayerOneImage: CircularBlueImageView!
    @IBOutlet weak var bluePlayerOneLabel: UILabel!
    @IBOutlet weak var bluePlayerTwoImage: CircularBlueImageView!
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
        let currentPlayer = CurrentPlayer(currentPlayerId: "",gamerId: TabBarViewController.currentUser.uid, userName: TabBarViewController.currentUser.displayName ?? "N/A", teamRole: TeamRoles.blueOne.rawValue)
        DBService.postCurrentPlayer(currentPlayer: currentPlayer) { (error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        let game = GameModel(gameName: gameName.rawValue, gameType: gameTypeSelected.rawValue, numberOfPlayers: 2, teamA: [TabBarViewController.currentUser.uid, redPlayerTwo.gamerID], teamB: [bluePlayerOne.gamerID, bluePlayerTwo.gamerID], parkId: "1", gameDescription: nil, gameEndTime: nil, winners: nil, losers: nil, isTie: nil, formattedAdresss: "2", parkName: "3", lat: 0.0, lon: 0.0, gameID: "", witness: nil, duration: nil, isOver: false)
        DBService.postGame(gamePost: game) { (error , gameId) in
            if let error = error {
                self.showAlert(title: "Error posting game", message: error.localizedDescription)
            }
            if let gameId = gameId {
                let redPlayerTwoInvitation = Invitation(invitationId: "", gameId: gameId, sender: TabBarViewController.currentUser.uid, reciever: redPlayerTwo.gamerID, message: "Invitation", approval: false, lat: 0, lon: 0, game: self.gameTypeSelected.rawValue, senderUsername: TabBarViewController.currentUser.displayName ?? "")
                let bluePlayerOneInvitation = Invitation(invitationId: "", gameId: gameId, sender: TabBarViewController.currentUser.uid, reciever: bluePlayerOne.gamerID, message: "Invitation", approval: false, lat: 0, lon: 0, game: self.gameTypeSelected.rawValue, senderUsername: TabBarViewController.currentUser.displayName ?? "")
                let bluePlayerTwoInviation = Invitation(invitationId: "", gameId: gameId, sender: TabBarViewController.currentUser.uid, reciever: bluePlayerTwo.gamerID, message: "Invitation", approval: false, lat: 0, lon: 0, game: self.gameTypeSelected.rawValue, senderUsername: TabBarViewController.currentUser.displayName ?? "")
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
