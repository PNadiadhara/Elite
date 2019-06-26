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

    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //let multiPeerConnectivityHelper = MultiPeerConnectivityHelper()
//    var session = MCSession()
//    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
//    var mcSession: MCSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: revisit
        MultiPeerConnectivityHelper.shared.multipeerDelegate = self
//        mcSession = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
//        mcSession?.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelPressed(_ sender: Any) {
        MultiPeerConnectivityHelper.shared.cancelJoinGame()
        loadingView.isHidden = true
    }
    @IBAction func hostGamePressed(_ sender: Any) {
//        multiPeerConnectivityHelper.hostGame()
        let createGameVC = CreateGameViewController()
        MultiPeerConnectivityHelper.shared.team = .RedPlayer
        present(createGameVC, animated: true)
    }
    
    @IBAction func joinGamePressed(_ sender: Any) {
        MultiPeerConnectivityHelper.shared.joinGame(joiningGame: false)
        loadingView.isHidden = false
        activityIndicator.startAnimating()
        MultiPeerConnectivityHelper.shared.team = .BluePlayer 
    }
    

}
extension HostJoinGameViewController: MultipeerConnectivityDelegate{
    func joinedGame() {
        
    }
    

    
    func receivedUserData(data: Data) {
        
    }
    
    func connected(to User: String) {
        
    }
    

    
    func acceptedInvitation() {
        
    }
    
    func invitePlayer(browser: MCNearbyServiceBrowser, peerID: MCPeerID, seesion: MCSession) {
        
    }
    
    func invitationNotification(handler: @escaping (Bool) -> Void) {
        
    }
    

    
    func foundAdverstiser(availableGames: [String]) {
        let parkList = ParkListViewController()
        parkList.typeOfList = .AvailableGameList
        parkList.availableGames = availableGames
        present(parkList, animated: true)
    }
    

    


    
    func displayAvailableGames(handler: @escaping (Bool) -> Void) {
        invitationAlert(title: "Invited", message: "Invited") { (action) in
            if action.title == "Yes"{
                 handler(true)
            }
        }
       
    }
    



    
    
}
