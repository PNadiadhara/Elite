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
    
    var invitation: Invitation!
    var selectedTeam: Teams?
    var currentPlayerTeamRole = String()
    var winnerConfirmationId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestures()
        fetchCurrentRole()
    }
    @IBAction func confirmPressed(_ sender: UIButton) {
        guard let selectedTeam = selectedTeam else {
            showAlert(title: "Please select winner", message: nil)
            return
        }
        DBService.updateWinningConfirmation(teamSelected: selectedTeam.rawValue, winningConfimationId: winnerConfirmationId, currentPlayerTeamRole: currentPlayerTeamRole)
        
//        let tab = TabBarViewController.setTabBarVC()
//        self.present(tab, animated: true)
    }
    func fetchCurrentRole() {
        DBService.fetchCurrentGamerTeamRole(gamerId: TabBarViewController.currentUser.uid) { (error, role) in
            if let error = error {
                print(error)
            }
            if let role = role {
                self.currentPlayerTeamRole = role
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
    }
    @objc func bluePlayerTap() {
        selectedTeam = .blue
    }
}

extension EndGameViewController {
    func createWinningConfirmation() {
        let winnerConfirmation = WinnerConfirmation(gameId: invitation.gameId, winnerConfirmationId: "", bluePlayerOne: nil, bluePlayerTwo: nil, bluePlayerThree: nil, bluePlayerFour: nil, bluePlayerFive: nil, redPlayerOne: nil, redPlayerTwo: nil, redPlayerThree: nil, redPlayerFour: nil, redPlayerFive: nil)
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
