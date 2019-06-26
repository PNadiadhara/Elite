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
    @IBOutlet weak var redOnePlayerLabel: UILabel!
    
    @IBOutlet weak var redTwoPlayerLabel: UILabel!
    @IBOutlet weak var redThreePlayerLabel: UILabel!
    @IBOutlet weak var redFourPlayerLabel: UILabel!
    
    @IBOutlet weak var redFivePlayerLabel: UILabel!
    @IBOutlet weak var blueOnePlayerLabel: UILabel!
    @IBOutlet weak var blueTwoPlayerLabel: UILabel!
    @IBOutlet weak var blueThreePlayerLabel: UILabel!
    @IBOutlet weak var blueFourPlayerLabel: UILabel!
    @IBOutlet weak var blueFivePlayerLabel: UILabel!
    @IBOutlet weak var redPlayerImage: UIImageView!
    @IBOutlet weak var bluePlayerImage: UIImageView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    
    var selectedTeam: Teams?
//    var game: GameModel?
//    var currentPlayer: CurrentPlayer?
//    var gameType: GameType!
//    var blueOnePlayer: GamerModel!
//    var redOnePlayer: GamerModel!
    var gameBegginingTimeStamp: Date?
    var gameEndTimeStamp: Date?
//    var currentPlayerTeamRole = String()
//    var winnerConfirmationId = String()
//    var isHost = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestures()
        setupUI()
        selectedTeam = .redTeam
        redPlayerView.alpha = 1
        MultiPeerConnectivityHelper.shared.multipeerWinnerVotesDelegate = self
    }
    func setupUI(){

    }
    func calculateGameDuration(beginningTimeStamp: Date?, endTimeStamp: Date?) -> String {
        guard let beginningTimeStamp = beginningTimeStamp,
            let endTimeStamp = endTimeStamp else {return String()}
        let difference = Calendar.current.dateComponents([.hour, .minute], from: beginningTimeStamp, to: endTimeStamp)
        return String(format: "%02ld%02ld", difference.hour!, difference.minute!)
    }
    private func submitVote(winner: String, winnerTeam: String) {
        let winnerVote = WinnerVotes(player: winner, winnerTeam: winnerTeam)
        MultiPeerConnectivityHelper.shared.winnerVotes.append(winnerVote)
        do{
            let data = try PropertyListEncoder().encode(winnerVote)
            let action = MultiPeerConnectivityHelper.Action.choseWinner.rawValue
            let dataToSend = DataToSend(action: action, data: data)
            MultiPeerConnectivityHelper.shared.convertDataToSendToDataAndSend(dataToSend: dataToSend)
        }catch{
            print("Property list encoding error \(error)")
        }
        
    }
//    func fetchWinningConfirmations(){
//        DBService.fetchWinningConfirmations(gameId: invitation.gameId) { (error, winningConfirmation) in
//            if let error = error {
//                print(error)
//            }
//            if let winningConfirmation = winningConfirmation {
//                self.winnerConfirmationId = winningConfirmation.winnerConfirmationId!
//            }
//        }
//    }
//    func fetchGame() {
//        DBService.fetchGame(gameId: invitation.gameId) { (error, game) in
//            if let error = error {
//                print("Error Fetching Games: \(error)")
//            }
//            if let game = game {
//
//                self.game = game
//
//            }
//        }
//    }
    @IBAction func confirmPressed(_ sender: UIButton) {
        guard let selectedTeam = selectedTeam else {
            showAlert(title: "Please select winner", message: nil)
            return
        }
        guard let winner = MultiPeerConnectivityHelper.shared.winner else {
            print("Error: No winner!!!")
            return}
        confirmAlert(title: "Winner: \(winner.username)", message: "Are you sure?") { (Done) in
            self.submitVote(winner: winner.username, winnerTeam: selectedTeam.rawValue)
            
            
//            MultiPeerConnectivityHelper.shared.numberOfVotes += 1
        }
        
        
//        guard let game = game  else {
//            print("No Game")
//            return
//        }

        
//        DBService.updateWinningConfirmation(teamSelected: selectedTeam.rawValue, winningConfimationId: self.winnerConfirmationId, currentPlayerTeamRole: self.currentPlayerTeamRole)
//        let winnerVc = WinnerViewController(nibName: "WinnerViewController", bundle: nil)
//        winnerVc.invitation = self.invitation
//        winnerVc.game = game
//        winnerVc.winnerConfirmationId = self.winnerConfirmationId
//        winnerVc.currentPlayer = self.currentPlayer
//        winnerVc.isHost = self.isHost
//        winnerVc.gameDuration = calculateGameDuration(beginningTimeStamp: gameBegginingTimeStamp, endTimeStamp: gameEndTimeStamp)
//        winnerVc.modalPresentationStyle = .overCurrentContext
//        self.present(winnerVc, animated: true)
        
//        let tab = TabBarViewController.setTabBarVC()
//        self.present(tab, animated: true)
    }
//    func fetchCurrentRole() {
//        DBService.fetchCurrentPlayer(gamerId: TabBarViewController.currentUser.uid) { (error, currentPlayer) in
//            if let error = error {
//                print(error)
//            }
//            if let currentPlayer = currentPlayer{
//                self.currentPlayerTeamRole = currentPlayer.teamRole
//                self.currentPlayer = currentPlayer
//
//            }
//        }
//    }
    func setupTapGestures() {
        let redPlayerViewTap = UITapGestureRecognizer(target: self, action: #selector(redPlayerTap))
        let bluePlayerViewTap = UITapGestureRecognizer(target: self, action: #selector(bluePlayerTap))
        redPlayerView.addGestureRecognizer(redPlayerViewTap)
        bluePlayerView.addGestureRecognizer(bluePlayerViewTap)
    }
    @objc func redPlayerTap() {
        
        selectedTeam = .redTeam
        redPlayerView.alpha = 1
        bluePlayerView.alpha = 0.5
        MultiPeerConnectivityHelper.shared.winner = MultiPeerConnectivityHelper.shared.redPlayer
        
    }
    @objc func bluePlayerTap() {
        selectedTeam = .blueTeam
        redPlayerView.alpha = 0.5
        bluePlayerView.alpha = 1.0
        MultiPeerConnectivityHelper.shared.winner = MultiPeerConnectivityHelper.shared.bluePlayer

    }
    /*TO DO: func to checkmark the selected image
     func to segue to winnerVC and pass inviation
    */
}
extension EndGameViewController: MultipeerConnectivityWinnerVotesDelegate {
    func winnerVotedReceived(data: Data) {
        do {
            let winnerVote = try PropertyListDecoder().decode(WinnerVotes.self, from: data)
            MultiPeerConnectivityHelper.shared.winnerVotes.append(winnerVote)
            
        }catch {
            print ("property list dedoding error:\(error)")
        }
        
    }
    
    func countIsTrue() {
        //TO DO: SEGUE TO WINNER CONFIRMATION
        print("Count is true")
    }
}
//extension EndGameViewController {
//    func createWinningConfirmation() {
//        let winnerConfirmation = WinnerConfirmation(gameId: invitation.gameId, winnerConfirmationId: nil, bluePlayerOne: nil, bluePlayerTwo: nil, bluePlayerThree: nil, bluePlayerFour: nil, bluePlayerFive: nil, redPlayerOne: nil, redPlayerTwo: nil, redPlayerThree: nil, redPlayerFour: nil, redPlayerFive: nil)
//        DBService.postWinnerConfirmation(winningConfirmation: winnerConfirmation) { (error, winningConfirmationId) in
//            if let error = error {
//                self.showAlert(title: "Error creating confirmation", message: error.localizedDescription)
//            }
//            if let winningConfirmationId = winningConfirmationId {
//                self.winnerConfirmationId = winningConfirmationId
//            }
//        }
//    }
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
//}
