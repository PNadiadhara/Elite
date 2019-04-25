//
//  EndGameViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 4/18/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit


class EndGameViewController: UIViewController {

    @IBOutlet weak var redPlayerView: UIView!
    @IBOutlet weak var bluePlayerView: UIView!
    @IBOutlet weak var redPlayerImage: CircularRedImageView!
    @IBOutlet weak var bluePlayerImage: CircularBlueImageView!
    @IBOutlet weak var redPlayerName: UILabel!
    @IBOutlet weak var bluePlayerName: UILabel!
    
    var invitation: Invitation!
    var selectedTeam: Teams?
    var game: GameModel?
    var currentPlayer: CurrentPlayer?
    var gameType: GameType!
    
    var currentPlayerTeamRole = String()
    var winnerConfirmationId = String()
    var isHost = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestures()
        if isHost {
           createWinningConfirmation()
        } else {
            fetchWinningConfirmations()
        }
        fetchCurrentRole()
        fetchGame()
    }
    
    func fetchWinningConfirmations(){
        DBService.fetchWinningConfirmations(gameId: invitation.gameId) { (error, winningConfirmation) in
            if let error = error {
                print(error)
            }
            if let winningConfirmation = winningConfirmation {
                self.winnerConfirmationId = winningConfirmation.winnerConfirmationId!
            }
        }
    }
    func fetchGame() {
        DBService.fetchGame(gameId: invitation.gameId) { (error, game) in
            if let error = error {
                print("Error Fetching Games: \(error)")
            }
            if let game = game {
                self.game = game
            }
        }
    }
    @IBAction func confirmPressed(_ sender: UIButton) {
        guard let selectedTeam = selectedTeam else {
            showAlert(title: "Please select winner", message: nil)
            return
        }
        guard let game = game  else {
            print("No Game")
            return
        }
        DBService.updateGameModel(gameId: invitation.gameId, game: game) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }

        }
        DBService.updateWinningConfirmation(teamSelected: selectedTeam.rawValue, winningConfimationId: self.winnerConfirmationId, currentPlayerTeamRole: self.currentPlayerTeamRole)
        let winnerVc = WinnerViewController(nibName: "WinnerViewController", bundle: nil)
        winnerVc.invitation = self.invitation
        winnerVc.game = game
        winnerVc.winnerConfirmationId = self.winnerConfirmationId
        winnerVc.currentPlayer = self.currentPlayer
        winnerVc.modalPresentationStyle = .overCurrentContext
        self.present(winnerVc, animated: true)
        
//        let tab = TabBarViewController.setTabBarVC()
//        self.present(tab, animated: true)
    }
    func fetchCurrentRole() {
        DBService.fetchCurrentPlayer(gamerId: TabBarViewController.currentUser.uid) { (error, currentPlayer) in
            if let error = error {
                print(error)
            }
            if let currentPlayer = currentPlayer{
                self.currentPlayerTeamRole = currentPlayer.teamRole
                self.currentPlayer = currentPlayer
                
            }
        }
    }
    func setupTapGestures() {
        let redPlayerViewTap = UITapGestureRecognizer(target: self, action: #selector(redPlayerTap))
        let bluePlayerViewTap = UITapGestureRecognizer(target: self, action: #selector(bluePlayerTap))
        redPlayerView.addGestureRecognizer(redPlayerViewTap)
        bluePlayerView.addGestureRecognizer(bluePlayerViewTap)
    }
    @objc func redPlayerTap() {
        selectedTeam = .red
        redPlayerImage.image = UIImage(named: "checkMark")
        
    }
    @objc func bluePlayerTap() {
        selectedTeam = .blue
        bluePlayerImage.image = UIImage(named: "checkMark")
    }
    /*TO DO: func to checkmark the selected image
     func to segue to winnerVC and pass inviation
    */
}

extension EndGameViewController {
    func createWinningConfirmation() {
        let winnerConfirmation = WinnerConfirmation(gameId: invitation.gameId, winnerConfirmationId: nil, bluePlayerOne: nil, bluePlayerTwo: nil, bluePlayerThree: nil, bluePlayerFour: nil, bluePlayerFive: nil, redPlayerOne: nil, redPlayerTwo: nil, redPlayerThree: nil, redPlayerFour: nil, redPlayerFive: nil)
        DBService.postWinnerConfirmation(winningConfirmation: winnerConfirmation) { (error, winningConfirmationId) in
            if let error = error {
                self.showAlert(title: "Error creating confirmation", message: error.localizedDescription)
            }
            if let winningConfirmationId = winningConfirmationId {
                self.winnerConfirmationId = winningConfirmationId
            }
        }
    }
//    func voteForBlueTeam(team: String){
//        var winnerConfirmation: WinnerConfirmation!
//        switch currentPlayerTeamRole {
//        case "blueOne":
//            //TODO create an instance of game when you hit play
//
//
//            
//        default:
//            return
//        }
//    }
}
