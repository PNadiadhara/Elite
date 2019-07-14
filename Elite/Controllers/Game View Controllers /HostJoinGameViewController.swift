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

    
    var waitingView: UIView?
    
    //let multiPeerConnectivityHelper = MultiPeerConnectivityHelper()
//    var session = MCSession()
//    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
//    var mcSession: MCSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        TimerPopUp.actionHandlerDelegate = self
        MultiPeerConnectivityHelper.shared.multipeerDelegate = self
        WaitingView.watingViewDelegate = self
        WaitingView.setViewContraints(titleText: "Searching for games", isHidden: true, delegate: self, view: self.view) { (waitingView) in
            self.waitingView = waitingView
        }
    }
    

    @IBAction func hostGamePressed(_ sender: Any) {
//        multiPeerConnectivityHelper.hostGame()
        let createGameVC = CreateGameViewController()
        MultiPeerConnectivityHelper.shared.role = .Host
        present(createGameVC, animated: true)
    }
    
    @IBAction func joinGamePressed(_ sender: Any) {
        MultiPeerConnectivityHelper.shared.joinGame(joiningGame: false)
        waitingView?.isHidden = false
        MultiPeerConnectivityHelper.shared.role = .Guest
    }
    

}
extension HostJoinGameViewController: MultipeerConnectivityDelegate{
    func foundAdverstiser(availableGames: [GamerModel]) {
        let parkList = ParkListViewController()
        
        parkList.typeOfList = .AvailableGameList
        parkList.availableGames = availableGames
        waitingView?.isHidden = true
        parkList.modalPresentationStyle = .overCurrentContext
        present(parkList, animated: true)
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
        MultiPeerConnectivityHelper.shared.joiningGame = nil
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
