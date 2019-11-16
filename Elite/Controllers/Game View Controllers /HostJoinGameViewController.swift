//
//  HostJoinGameViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 6/15/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class HostJoinGameViewController: UIViewController{
    //TO DO: GAMERESTRICTION for 20 minutes
    
    @IBOutlet weak var restrictionView: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    var waitingView: UIView?
    var countdownTimer = Timer()
    var time = Int()
    var count = 0
    var timerRunning = false
    //let multiPeerConnectivityHelper = MultiPeerConnectivityHelper()
//    var session = MCSession()
//    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
//    var mcSession: MCSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimerPopUp.actionHandlerDelegate = self
//        DBService.updatePlayersWinsBasketBall(parkId: "006049d9-835c-451e-ac17-a4eaf827b397", playerId: TabBarViewController.currentUser.uid, sport: "") { (error) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        }

        

        WaitingView.setViewContraints(titleText: "Searching for games", isHidden: true, delegate: self, view: self.view) { (waitingView) in
            self.waitingView = waitingView
        }

    }
    


    func checkFor20minsLimit(completion: @escaping(Bool) -> Void) {
        GameRestrictionsHelper.checkIfGameIsWithin20Mins(gamerId: GamerModel.currentGamer.gamerID) { (error, okayToPlay, timeLeft) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let okayToPlay = okayToPlay,
                let timeLeft = timeLeft {
                if !okayToPlay {
                    self.time = 1200 - timeLeft
                    self.startTimer()
                    self.restrictionView.isHidden = false
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    @IBAction func hostGamePressed(_ sender: Any) {
        if !GameRestrictionsHelper.test {
            checkFor20minsLimit { (okayToPlay) in
                if okayToPlay {
                    let createGameVC = CreateGameViewController()
                    MultiPeerConnectivityHelper.shared.role = .Host
                    self.navigationController?.pushViewController(createGameVC, animated: true)
                }
            }
        } else {
            let createGameVC = CreateGameViewController()
            MultiPeerConnectivityHelper.shared.role = .Host
            self.navigationController?.pushViewController(createGameVC, animated: true)
        }
//        multiPeerConnectivityHelper.hostGame()

    }
    
    private func joinGame() {
        MultiPeerConnectivityHelper.shared.multipeerDelegate = self
        WaitingView.watingViewDelegate = self
        MultiPeerConnectivityHelper.shared.joinGame(joiningGame: false)
        self.waitingView?.isHidden = false
        MultiPeerConnectivityHelper.shared.role = .Guest
    }
    
    @IBAction func joinGamePressed(_ sender: Any) {
        if !GameRestrictionsHelper.test {
            checkFor20minsLimit { (okayToPlay) in
                if okayToPlay {
                    self.joinGame()
                }
            }
        } else {
            self.joinGame()
        }

    }
    
    func startTimer() {
        if !timerRunning{
            timerRunning = true
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(time))"
        
        if time != 0 {
            time -= 1
        } else {
            restrictionView.isHidden = true
            timerRunning = false
            endTimer()
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }


}
extension HostJoinGameViewController: MultipeerConnectivityDelegate{
    func foundAdverstiser(availableGames: [GamerModel]) {
        let parkList = ParkListViewController()
        parkList.typeOfList = .AvailableGameList
        parkList.availableGames = availableGames
        waitingView?.isHidden = true
        self.navigationController?.pushViewController(parkList, animated: true)
    }
    
    func playerWantsToJoinGame(player: GamerModel, handler: @escaping (Bool) -> Void) {
        
    }
    

    func countIsTrue() {
        
    }
    

    
    func receivedUserData(data: Data, role: String) {
        
    }
    
    func connected(to User: String) {
        
    }
    

    
    func acceptedInvitation() {
        
    }
    
    func invitePlayer(browser: MCNearbyServiceBrowser, peerID: MCPeerID, seesion: MCSession) {
        
    }
    

    

    

    

    


    
//    func displayAvailableGames(handler: @escaping (Bool) -> Void) {
//
//
//        
////        invitationAlert(title: "Invited", message: "Invited") { (action) in
////            if action.title == "Yes"{
////                 handler(true)
////            }
////        }
//
//    }
    



    
    
}

extension HostJoinGameViewController: WaitingViewDelegate {
    func cancelPressed() {
        MultiPeerConnectivityHelper.shared.cancelJoinGame()
        waitingView?.isHidden = true
    }
    
    
}

extension HostJoinGameViewController: MultipeerConnectivityActionHandlerDelegate {
    func userPressedRetry() {
        
    }
    
    func userDidQuitGame() {
        self.viewDidLoad()
    }
    
    
}
