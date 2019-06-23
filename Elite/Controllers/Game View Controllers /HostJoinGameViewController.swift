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

    @IBAction func hostGamePressed(_ sender: Any) {
//        multiPeerConnectivityHelper.hostGame()
        let createGameVC = CreateGameViewController()
        present(createGameVC, animated: true)
    }
    
    @IBAction func joinGamePressed(_ sender: Any) {
        MultiPeerConnectivityHelper.shared.joinGame(joiningGame: false)
    }
    

}
extension HostJoinGameViewController: MultipeerConnectivityDelegate{
    func dataRecieved(data: Data) {
        
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
