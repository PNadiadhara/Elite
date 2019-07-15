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
    func countIsTrue()
    func receivedUserData(data: Data, role: String)
    func foundAdverstiser(availableGames: [GamerModel])
    func connected(to User: String)
}
protocol MultipeerConnectivityWinnerVotesDelegate: AnyObject {
    func countIsTrue()
    func winnerVotedReceived(data: Data)
}

protocol MultipeerConnectivityPlayerWantsToJoinDelegate: AnyObject {
    func playerWantsToJoinGame(player: GamerModel,handler: @escaping(Bool) -> Void )
}
protocol MultipeerConnectivityActionHandlerDelegate: AnyObject {
    func userDidQuitGame()
    func userPressedRetry()
}

protocol MultipeerConnectivityGameModelDelegate: AnyObject {
    func hostSentParkId(parkId: String)
}

class DataToSend: Codable {
    var action: String
    var data: Data?
    var team: String?
    init(action: String, data: Data?, team: String?) {
        self.action = action
        self.data = data
        self.team = team
    }
}

class WinnerVotes: Codable {
    var player: String
    var winnerTeam: String
    
    init(player: String, winnerTeam: String) {
        self.player = player
        self.winnerTeam = winnerTeam
    }
}

class GameModelToSend: Codable {
    var gameName: String
    var gameType: String
    var parkId: String
    var formattedAddress: String
    var parkName: String
    var lat: String
    var lon: String
    var gameId: String
    
    init(gameName: String, gameType: String, parkId: String, formattedAddress: String, parkName: String, lat: String, lon: String, gameId: String) {
        self.gameName = gameName
        self.gameType = gameType

        self.parkId = parkId
        self.formattedAddress = formattedAddress
        self.parkName = parkName
        self.lat = lat
        self.lon = lon
        self.gameId = gameId
    }
}

class MultiPeerConnectivityHelper: NSObject {
    
    
    enum Teams: String {
        case BluePlayer
        case RedPlayer
    }
    
    enum Role: String {
        case Host
        case Guest
    }
    
    enum Action: String {
        case sendUserInfo
        case joinedGame
        case startedTimer
        case sharedTimerChanged
        case pauseSharedTimer
        case resumeSharedTimer
        case stopTimer
        case runSharedTimer
        case canceledGame
        case finishedGame
        case choseWinner
        case retryWinnerVote
        case sendGameModel
        case sendParkId
    }
    
    enum ButtonStatus {
        case Play
        case Pause
    }

    public var team: Teams?
    public var role: Role?
    public var redPlayer: GamerModel?
    public var bluePlayer: GamerModel?
    public var rival: GamerModel? {
        didSet {
            multipeerDelegate?.countIsTrue()
        }
    }
    
    public var buttonStatus = ButtonStatus.Pause
    public var winnerVotes = [WinnerVotes]() { //EMPTY WHEN END OF SESSION
        didSet{
            if checkForCount(count: winnerVotes.count) {
                multipeerWinnerVotesDelegate?.countIsTrue()
            }
        }
    }
    public var numberOfPlayersJoined = 0 {
        didSet{
            if checkForCount(count: numberOfPlayersJoined) {
              multipeerDelegate?.countIsTrue()
            }
        }
    }
    private let serviceType = "elite-elite"
    
    weak var multipeerDelegate: MultipeerConnectivityDelegate?
    weak var timerDelegate: TimerDelegate?
    weak var multipeerWinnerVotesDelegate: MultipeerConnectivityWinnerVotesDelegate?
    weak var multipeerActionHandlerDelegate: MultipeerConnectivityActionHandlerDelegate?
    weak var multipeerGameModelDelegate: MultipeerConnectivityGameModelDelegate?
    weak var multipeerConnectivityPlayerWantsToJoinDelegate: MultipeerConnectivityPlayerWantsToJoinDelegate?
    
    private var listOfAvailableGames = [String]()
    
    public var joiningGame: Bool? //
    
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
    
    public func stopBrowsingAndAdverstising() {
        advertiserAssistant.stop()
        serviceBrowser.stopBrowsingForPeers()
    }
    
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
    public func endSession() {
        session.disconnect()
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
        team = nil
        role = nil
        redPlayer = nil
        bluePlayer = nil
        rival = nil
        winnerVotes.removeAll()
        numberOfPlayersJoined = 0
        joiningGame = Bool()
        MainTimer.shared.stopTimer()
    }
    
    func checkForCount(count: Int) -> Bool {
        
        if count < 2 {
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
    
    public func sendGameModel(gameModelToSend: GameModelToSend) {
        do {
            let data = try PropertyListEncoder().encode(gameModelToSend)
            MultiPeerConnectivityHelper.shared.sendDataToConnectedUsers(data: data)
        } catch {
            print("Property list encoding error \(error)")
        }
    }
    public func convertDataToSendToDataAndSend(dataToSend: DataToSend){
        do {
            let data = try PropertyListEncoder().encode(dataToSend)
            MultiPeerConnectivityHelper.shared.sendDataToConnectedUsers(data: data)
        } catch {
           print("Property list encoding error \(error)")
        }
    }
    public func sendDataToConnectedUsers(data: Data) {
        
        // 2
        if session.connectedPeers.count > 0 {
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
    public func sendGameModel() {
        let action = MultiPeerConnectivityHelper.Action.sendGameModel.rawValue
        
        do{
            guard let gameToSend = GameModel.game  else {
                print("Error: Game model is nil")
                return
            }
            let data = try PropertyListEncoder().encode(gameToSend)
            let dataToSend = DataToSend(action: action, data: data, team: nil)
            MultiPeerConnectivityHelper.shared.convertDataToSendToDataAndSend(dataToSend: dataToSend)
        }catch{
            print("Property list encoding error \(error)")
        }
        
        
    }
    public func sendParkID(parkId: String, done: () -> Void) {
        let action = MultiPeerConnectivityHelper.Action.sendParkId.rawValue
        let data = Data(parkId.utf8)
        let dataToSend = DataToSend(action: action, data: data, team: nil)
        MultiPeerConnectivityHelper.shared.convertDataToSendToDataAndSend(dataToSend: dataToSend)
        done()
    }
    
    public func decodeDataToGameSendModel(gameModelData: Data) {
        do {
            let gameSentData =  try PropertyListDecoder().decode(GameModelToSend.self, from: gameModelData)
            GameModel.parkId = gameSentData.parkId
            GameModel.gameName = gameSentData.gameName
            GameModel.gameTypeSelected = "1 vs. 1"
            GameModel.formattedAddress = gameSentData.formattedAddress
            GameModel.parkLat = gameSentData.lat
            GameModel.parkLon = gameSentData.lon
            GameModel.gameId = gameSentData.gameId
            
        } catch {
            print("Error decoding: \(error.localizedDescription)")
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
            var dataRecieved: DataToSend?
            
            do {
                dataRecieved = try PropertyListDecoder().decode(DataToSend.self, from: data)
                guard let sentData = dataRecieved else {return}
                print(sentData.action)
                switch sentData.action {
                case Action.sendUserInfo.rawValue:
                    self!.multipeerDelegate?.receivedUserData(data: sentData.data!, role: sentData.team!)
                case Action.joinedGame.rawValue:
                    self?.numberOfPlayersJoined += 1
                case Action.startedTimer.rawValue:
                    MainTimer.shared.runTimer()
                case Action.pauseSharedTimer.rawValue:
                    MainTimer.shared.suspend()
                    self?.buttonStatus = ButtonStatus.Play
                    self?.timerDelegate?.changedButtonText(text: "Play")
                case Action.resumeSharedTimer.rawValue:
                    MainTimer.shared.resume()
                    self?.buttonStatus = ButtonStatus.Pause
                    self?.timerDelegate?.changedButtonText(text: "Pause")
                case Action.finishedGame.rawValue:
                    self?.timerDelegate?.finishedTimer()
                case Action.choseWinner.rawValue:
                    self?.multipeerWinnerVotesDelegate?.winnerVotedReceived(data: sentData.data!)
                case Action.canceledGame.rawValue:
                    self?.timerDelegate?.cancelledTimer()
                case Action.retryWinnerVote.rawValue:
                    self?.multipeerActionHandlerDelegate?.userPressedRetry()
                case Action.sendGameModel.rawValue:
                    return
                case Action.sendParkId.rawValue:
                    self?.multipeerGameModelDelegate?.hostSentParkId(parkId: String(data: sentData.data!, encoding: .utf8)!)
//                    self?.numberOfVotes += 1
                default:
                    print("No action Sent")
                    
                }
            }catch {
                print ("property list dedoding error:\(error)")
            }
//            let recievedData = String(data: data, encoding: .utf8)
//            if recievedData == Action.joinedGame.rawValue {
//                self?.numberOfPlayersJoined += 1
//            }
//            if recievedData == Action.startedTimer.rawValue{
//                let delegateTime = MainTimer.shared.timeString(time: TimeInterval(MainTimer.shared.time))
//                self!.timerDelegate?.timerIsRunning(time: delegateTime)
//            }
//            self!.multipeerDelegate?.receivedUserData(data: data)
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
//        listOfAvailableGames.append(peerID.displayName)
        DBService.fetchGamersBasedOnDeviceName(deviceName: peerID.displayName) { (error, listOfAvailableGames) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let listOfAvaliableGames = listOfAvailableGames {
                self.multipeerDelegate?.foundAdverstiser(availableGames: listOfAvaliableGames)
            }
        }
        
        if joiningGame ?? false {
            browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 45)
            multipeerDelegate?.acceptedInvitation()
            
        }
        listOfAvailableGames.removeAll()
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
        DBService.fetchGamerBasedOnDeviceName(deviceName: peerID.displayName) { (error, gamer) in
            if let error = error{
                print("error fetching device name: \(error.localizedDescription)")
            }
            if let gamer = gamer {
            self.multipeerConnectivityPlayerWantsToJoinDelegate?.playerWantsToJoinGame(player: gamer, handler: { (answer) in
                    if answer {
                        invitationHandler(true, self.session)
                    }
                })
            }
        }
//        multipeerDelegate?.invitationNotification(handler: { (anwser) in
//            if anwser {
//                invitationHandler(true, self.session)
//            }
//        })
        
        
    }
    
}
extension MultiPeerConnectivityHelper: MCAdvertiserAssistantDelegate {
    func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        
    }
    func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        
    }
}

