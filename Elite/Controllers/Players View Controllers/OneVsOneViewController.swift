//
//  OneVsOneViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import MultipeerConnectivity


enum SelectedInvitationOption {
    case accepted
    case declined
}
class OneVsOneViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchPlayerView: versusLeft!
    @IBOutlet weak var redPlayerLabel: UILabel!
    @IBOutlet weak var bluePlayerLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var redPlayerRanking: UILabel!
    @IBOutlet weak var redPlayerMedalImage: UIImageView!
    @IBOutlet weak var bluePlayerRanking: UILabel!
    @IBOutlet weak var bluePlayerMedal: UIImageView!
    
    @IBOutlet weak var redPlayerImage: CircularRedImageView!
    
    @IBOutlet weak var bluePlayerImage: CircularBlueImageView!
    //    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var waitingPlayersLabel: UILabel!
//    @IBOutlet weak var cancelHostingButton: UIButton!
//    @IBOutlet weak var waitingView: UIView!
    
//
//    var gamerSelected: GamerModel?
//    var invitation: Invitation?
//    var invitations = [Invitation]()
    var gameName: GameName?


    var waitingView: UIView?
 
//    var bluePlayer: GamerModel? {
//        didSet {
//            setupSentUI()
//        }
//    }
  
    //var multiPeerHelper = MultiPeerConnectivityHelper()
   
    //TO DO: Create a park
    var selectedInvitationOption: SelectedInvitationOption = .accepted
    
    private var listener: ListenerRegistration!
    
    var inviteResponse: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
//        let cgRect = CGRect(x: 0, y: 0, width: 207, height: 269)

        MultiPeerConnectivityHelper.shared.multipeerDelegate = self
        MultiPeerConnectivityHelper.shared.multipeerConnectivityPlayerWantsToJoinDelegate = self
        playButton.isEnabled = false
//        activityIndicator.startAnimating()
        setupTap()
        sportLabel.text = gameName?.rawValue.capitalized

        WaitingView.setViewContraints(titleText: "Waiting for\nplayers to join", isHidden: false, delegate: self, view: self.view) { (waitingView) in
            self.waitingView = waitingView
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if let gamer = gamerSelected {
//            bluePlayerLabel.text = gamer.username
//            bluePlayerImage.image = UIImage(named: gamer.username + "FightingRight")
//        }
       

    }
    
    func getPlayersRanking() {
        DBService.getBBRankingByPark(parkId: "006049d9-835c-451e-ac17-a4eaf827b397") { (error, BBPlayers) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let BBPlayers = BBPlayers {
                print(BBPlayers.count)
            }
        }
    }
    
    func sendUserData(data: Data) {
        let action = MultiPeerConnectivityHelper.Action.sendUserInfo.rawValue
        let dataToSend = DataToSend(action: action, data: data, team: MultiPeerConnectivityHelper.shared.role?.rawValue)
        
        do {
            let data = try PropertyListEncoder().encode(dataToSend)
            MultiPeerConnectivityHelper.shared.sendDataToConnectedUsers(data: data)
        } catch {
            
        }
        
    }
    

    func fetchAndSendUser() {
        
        let gamer = TabBarViewController.currentGamer
            if let gamer = gamer {
                do{
                    let data = try PropertyListEncoder().encode(gamer)
                    
                    sendUserData(data: data)
                }catch{
                    print("Property list encoding error \(error)")
                }
            }
    }
    
    func setupSentUI() {
        guard let redPlayer = MultiPeerConnectivityHelper.shared.redPlayer,
        let bluePlayer = MultiPeerConnectivityHelper.shared.bluePlayer else {return}
        guard let bluePlayerImageURL = URL(string: bluePlayer.profileImage!),
        let redPlayerImageURL = URL(string: redPlayer.profileImage!) else {return}
        bluePlayerImage.kf.setImage(with: bluePlayerImageURL)
        redPlayerImage.kf.setImage(with: redPlayerImageURL)
        bluePlayerLabel.text = bluePlayer.username
        redPlayerLabel.text = redPlayer.username
//        guard let team = MultiPeerConnectivityHelper.shared.team,
//            let rival = MultiPeerConnectivityHelper.shared.rival else {return}
//        switch team{
//        case .BluePlayer:
//            bluePlayerLabel.text = TabBarViewController.currentUser.displayName
//            bluePlayerImage.image = UIImage(named: TabBarViewController.currentUser.displayName! + "FightingRight")
//            redPlayerLabel.text = rival.username
//            redPlayerImage.image = UIImage(named: rival.username + "FightingLeft")
//        case .RedPlayer:
//            redPlayerLabel.text = TabBarViewController.currentUser.displayName
//            redPlayerImage.image = UIImage(named: TabBarViewController.currentUser.displayName! + "FightingLeft")
//            bluePlayerLabel.text = rival.username
//            bluePlayerImage.image = UIImage(named: rival.username + "FightingRight")
//        }
    }
//        DBService.fetchCurrentPlayer(gamerId: TabBarViewController.currentGamer.gamerID , completion: { (error, currentPlayer) in
//            if let error = error {
//                print(error)
//            }
//            if let currentPlayer = currentPlayer {
//
//            }
//        })
    

    

    @IBAction func playButtonPressed(_ sender: UIButton) {
        printValues()
        if MultiPeerConnectivityHelper.shared.role == .Host {
            GameModel.createGame(gameName: GameModel.gameName!, gameType: "1 vs. 1", redTeam: [MultiPeerConnectivityHelper.shared.redPlayer!.gamerID], blueTeam: [MultiPeerConnectivityHelper.shared.bluePlayer!.gamerID], parkId: GameModel.parkId ?? "", formattedAdress: GameModel.formattedAddress ?? "", parkName: GameModel.parkSelected!, lat: GameModel.parkLat!, lon: GameModel.parkLon!, gameId: "", players: [MultiPeerConnectivityHelper.shared.redPlayer!.gamerID, MultiPeerConnectivityHelper.shared.bluePlayer!.gamerID])
        }
        
        let timerPopUp = TimerPopUp()
        present(timerPopUp, animated: true)
       
        
//        guard let gamerSelected = gamerSelected else {
//            showAlert(title: "Please select player", message: nil)
//            return
//        }
//        //To do: CREATE INSTANSE OF GAME
//
//        let game = GameModel(gameName: gameName.rawValue, gameType: gameTypeSelected.rawValue, numberOfPlayers: 2, redTeam: [TabBarViewController.currentUser.uid], blueTeam: [gamerSelected.gamerID], parkId: "1", gameDescription: nil, gameEndTime: nil, winners: nil, losers: nil, isTie: nil, formattedAdresss: "2", parkName: "3", lat: 0.0, lon: 0.0, gameID: "", witness: nil, duration: nil, isOver: false, wasCancelled: false)
//        DBService.postGame(gamePost: game) { (error, gameId) in
//            if let error = error {
//                self.showAlert(title: "Error posting game", message: error.localizedDescription)
//            }
//            if let gameId = gameId {
//                self.createCurrentGameRoles(gameId: gameId)
//                let invitation = Invitation(invitationId: "", gameId: gameId ,sender: TabBarViewController.currentUser.uid, reciever: gamerSelected.gamerID, message: "Invitation", approval: false, lat: 0.0, lon: 0.0, game: self.gameName.rawValue, senderUsername: TabBarViewController.currentUser.displayName ?? "", gameType: self.gameTypeSelected.rawValue)
//                DBService.postInvitation(invitation: invitation) { (error, invitationId) in
//                    if let error = error {
//                        self.showAlert(title: "Error posting invitation", message: error.localizedDescription)
//                    }
//                    if let invitationId = invitationId{
//                        DBService.fetchInvitation(inivtationId: invitationId, completion: { (error, invitation) in
//                            if let error = error {
//                                print(error.localizedDescription)
//                            }
//                            if let invitation = invitation {
//                                let oneVsoneProgressVc = OneVsOneProgressViewController.init(nibName: "OneVsOneProgressViewController", bundle: nil)
//                                oneVsoneProgressVc.modalPresentationStyle = .fullScreen
//                                oneVsoneProgressVc.invitation = invitation
//                                oneVsoneProgressVc.isHost = true
//                                oneVsoneProgressVc.gameType = .oneVsOne
//                                oneVsoneProgressVc.game = game
//                                oneVsoneProgressVc.redOnePlayer = TabBarViewController.currentGamer
//                                oneVsoneProgressVc.blueOnePlayer = gamerSelected
//                                self.present(oneVsoneProgressVc, animated: true)
//                            }
//                        })
//                        
//                    }
//                }
//            }
//        }
//
////        DBService.postInvitation(invitation: invitation) { (error ) in
////            print("Error posting message")
////        }
//

    }
//    func createCurrentGameRoles(gameId: String) {
//        let blueOnePlayer = CurrentPlayer(currentPlayerId: "", gamerId: gamerSelected!.gamerID, userName: gamerSelected!.username, teamRole: TeamRoles.blueOne.rawValue, gameId: gameId)
//        DBService.postCurrentPlayer(currentPlayer: blueOnePlayer) { (error) in
//            if let error = error {
//                self.showAlert(title: "Error", message: error.localizedDescription)
//            }
//        }
//        let redPlayerOne = CurrentPlayer(currentPlayerId: "",gamerId: TabBarViewController.currentUser.uid, userName: TabBarViewController.currentUser.displayName ?? "N/A", teamRole: TeamRoles.redOne.rawValue, gameId: gameId)
//        DBService.postCurrentPlayer(currentPlayer: redPlayerOne) { (error) in
//            if let error = error {
//                self.showAlert(title: "Error", message: error.localizedDescription)
//            }
//        }
//
//    }
    func printValues() {
//        print(GameModel.parkId) //
//        print(GameModel.gameName)
//        print(GameModel.gameTypeSelected)
//        print(GameModel.formattedAddress)//
//        print(GameModel.parkLat)//
//        print(GameModel.parkLon)//
//        print(GameModel.gameId)
//        GameModel.gameName = gameSentData.gameName
//        GameModel.gameTypeSelected = "1 vs. 1"
//        GameModel.formattedAddress = gameSentData.formattedAddress
//        GameModel.parkLat = gameSentData.lat
//        GameModel.parkLon = gameSentData.lon
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    

    

    
    
    func setupTap() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(searchPlayerPressed))
//        addPlayerView.addGestureRecognizer(tap)
    }

//    @objc func fetchInvitationRequest() {
//        listener = DBService.firestoreDB.collection(InvitationCollectionKeys.collectionKey).whereField("reciever", isEqualTo: user.uid)
//            .addSnapshotListener { [weak self] (snapshot, error) in
//                if let error = error {
//                    self?.showAlert(title: "Error fetching blogs", message: error.localizedDescription)
//                } else if let snapshot = snapshot {
//                    print("Invitation recieved")
//                    self?.invitations = snapshot.documents.map {Invitation.init(dict: $0.data())}
//                    if (self?.invitations.count)! > 0 {
//                        self?.presentAlertVC()
//                    }
//                }
//        }
//    }
//    @objc func searchPlayerPressed() {
//        let searchPlayerVc = SearchPlayerViewController.init(nibName: "SearchPlayerViewController", bundle: nil)
//        searchPlayerVc.modalPresentationStyle = .fullScreen
//        searchPlayerVc.searchDelegate = self
//        searchPlayerVc.teamRole = .blueOne
//        searchPlayerVc.gameType = .oneVsOne
//        present(searchPlayerVc, animated: true)
//
//    }
//    func presentAlertVC() {
//        let invitationAlertVC = InvitationAlertViewController.init(nibName: "InvitationAlertViewController", bundle: nil)
//        invitationAlertVC.invitation = invitations.first
//        invitationAlertVC.modalPresentationStyle = .overCurrentContext
//
//        present(invitationAlertVC, animated: true)
//    }
}

//extension OneVsOneViewController: SearchForPlayerDelegate{
//    func gamerSelected(gamer: GamerModel) {
//        self.gamerSelected = gamer
//    }
//
//
//}
//        static var parkId: String?
//        static var gameName: String?
//        static var gameTypeSelected: String?
//        static var parkSelected: String?
//        static var formattedAddress: String?
//        static var parkLat: String?
//        static var parkLon: String?

extension OneVsOneViewController: MultipeerConnectivityPlayerWantsToJoinDelegate {
    func playerWantsToJoinGame(player: GamerModel, handler: @escaping (Bool) -> Void) {
        let invitationPopUp = InvitationAlertViewController()
        invitationPopUp.gamer = player
        invitationAlert(title: "\(player.username!) wants to join game", message: nil) { (anwser) in
            if anwser.title == "Yes" {
                handler(true)
            }
        }
    }
}

extension OneVsOneViewController: MultipeerConnectivityDelegate{
    func foundAdverstiser(availableGames: [GamerModel]) {
        
    }
    
    func countIsTrue() {
        setupSentUI()
    }
    
    func receivedUserData(data: Data, role: String) {
        do {
            let playerData =  try PropertyListDecoder().decode(GamerModel.self, from: data)
            
            if role == MultiPeerConnectivityHelper.Role.Guest.rawValue {
                MultiPeerConnectivityHelper.shared.redPlayer = TabBarViewController.currentGamer
                MultiPeerConnectivityHelper.shared.bluePlayer = playerData
                print("Red Player: \(String(describing: MultiPeerConnectivityHelper.shared.bluePlayer!.username))")

            }
            if role == MultiPeerConnectivityHelper.Role.Host.rawValue {
                MultiPeerConnectivityHelper.shared.bluePlayer = TabBarViewController.currentGamer
                MultiPeerConnectivityHelper.shared.redPlayer = playerData
                print("Blue Player:  \(String(describing: MultiPeerConnectivityHelper.shared.redPlayer!.username))")
               
            }
            MultiPeerConnectivityHelper.shared.rival = playerData
        }catch {
            print ("property list dedoding error:\(error)")
        }
        
    }
    
    func connected(to User: String) {
        DispatchQueue.main.async {
                self.waitingView?.isHidden = true
                self.playButton.isEnabled = true
                self.fetchAndSendUser()
                MultiPeerConnectivityHelper.shared.stopBrowsingAndAdverstising()
            }
    }
    

    
    func acceptedInvitation() {
        
    }
    
    func invitePlayer(browser: MCNearbyServiceBrowser, peerID: MCPeerID, seesion: MCSession) {
        
    }
    
    
    func displayAvailableGames(handler: @escaping (Bool) -> Void) {
        return
    }
    
    

    
    
}

extension OneVsOneViewController: WaitingViewDelegate{
    func cancelPressed() {
        MultiPeerConnectivityHelper.shared.stopHosting()
        dismiss(animated: true)
    }
    
    
}

