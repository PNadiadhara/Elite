//
//  MultiPeerConnectivityHelper.swift
//  Elite
//
//  Created by Leandro Wauters on 6/15/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import MultipeerConnectivity



protocol MultipeerConnectivityDelegate: AnyObject {
    func acceptedInvitation()
    func joinedGame()
    func receivedUserData(data: Data)
    func foundAdverstiser(availableGames: [String])
    func invitationNotification(handler: @escaping(Bool) -> Void )
    func connected(to User: String)
}

class MultiPeerConnectivityHelper: NSObject {
    
    
    enum Role: String {
        case Guest
        case Host
    }
    
    enum Action: String {
        case sendUserInfo
        case joinedGame
        case startedTimer
    }
    public var role: Role!
    public var numberOfPlayersJoined = 0 {
        didSet{
            if checkForCount() {
              multipeerDelegate?.joinedGame()
            }
        }
    }
    private let serviceType = "elite-elite"
    
    weak var multipeerDelegate: MultipeerConnectivityDelegate?
    
    public var listOfAvailableGames = [String]()
    
    public var joiningGame = Bool()
    
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private var advertiserAssistant: MCAdvertiserAssistant!
    private let serviceBrowser : MCNearbyServiceBrowser
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    

    public var session: MCSession!
    
//    lazy var session : MCSession = {
//        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
//        session.delegate = self
//        return session
//    }()
    
    
//    lazy var session : MCSession = {
//        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference:  MCEncryptionPreference.optional)
//        session.delegate = self
//        return session
//    }()
    
    private override init() {
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)

        
        super.init()
        session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        advertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)
        
        session.delegate = self
        advertiserAssistant.delegate = self
        serviceBrowser.delegate = self
        serviceAdvertiser.delegate = self
        
    }
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
        
    }
    
    static var shared = MultiPeerConnectivityHelper()

    
    public func joinGame(joiningGame: Bool) {
        if joiningGame {
            self.joiningGame = true
            serviceBrowser.stopBrowsingForPeers()
        }
        serviceBrowser.startBrowsingForPeers()
    }
    
    public func cancelJoinGame(){
        serviceBrowser.stopBrowsingForPeers()
    }
    func checkForCount() -> Bool {
        
        if numberOfPlayersJoined < 2 {
            return false
        } 
        return true
        
    }
    
//    public func joinGame(game: String ) {
//        let peerID = MCPeerID(displayName: game)
//        serviceBrowser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
//
//    }
    public func hostGame() {
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    public func acceptedInvitation() {
        
    }
    
    public func stopHosting(){
        advertiserAssistant.stop()
    }
    

    public func sendDataToConnectedUsers(data: Data) {
        
        // 2
        if session.connectedPeers.count > 0 {
            print("GOOD!")
            // 3
            
            // 4
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("session error: \(error)")
                // 5
//                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .default))
//                present(ac, animated: true)
            }
        }
    }

}


extension MultiPeerConnectivityHelper: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            multipeerDelegate?.connected(to: peerID.displayName)
//            multipeerDelegate?.acceptedInvitation()
//            test()
//            serviceBrowser.stopBrowsingForPeers()
//            serviceAdvertiser.stopAdvertisingPeer()
            
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
//    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
//        certificateHandler(true)
//    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            let recievedData = String(data: data, encoding: .utf8)
            if recievedData == Action.joinedGame.rawValue {
                self?.numberOfPlayersJoined += 1
            }
            self!.multipeerDelegate?.receivedUserData(data: data)
        }
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}

extension MultiPeerConnectivityHelper : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        listOfAvailableGames.append(peerID.displayName)
        
        multipeerDelegate?.foundAdverstiser(availableGames: listOfAvailableGames)
        if joiningGame {
            browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
            multipeerDelegate?.acceptedInvitation()
            
            
        }
        //multipeerDelegate?.invitationAccepted(session: session)
//        multipeerDelegate?.displayAvailableGames(availableGames: listOfAvailableGames)
//        multipeerDelegate?.displayAvailableGames(handler: { (response) in
//            if response {
//               browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
//                self.multipeerDelegate?.invitationAccepted()
//            }
//        })
        
        

    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
    
}
extension MultiPeerConnectivityHelper : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        multipeerDelegate?.invitationNotification(handler: { (anwser) in
            if anwser {
                invitationHandler(true, self.session)
            }
        })
        
        
    }
    
}
extension MultiPeerConnectivityHelper: MCAdvertiserAssistantDelegate {
    func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        
    }
    func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        
    }
}

