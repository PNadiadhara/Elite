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
protocol SearchForPlayerDelegate: AnyObject {
    func gamerSelected(gamer: GamerModel)
}
enum SelectedInvitationOption {
    case accepted
    case declined
}
class OneVsOneViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchPlayerView: versusLeft!
    @IBOutlet weak var bluePlayerImage: UIImageView!
    @IBOutlet weak var redPlayerImage: UIImageView!
    @IBOutlet weak var redPlayerLabel: UILabel!
    @IBOutlet weak var bluePlayerLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addPlayerView: UIView!
    @IBOutlet weak var redPlayerRanking: UILabel!
    @IBOutlet weak var redPlayerMedalImage: UIImageView!
    @IBOutlet weak var bluePlayerRanking: UILabel!
    @IBOutlet weak var bluePlayerMedal: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var waitingPlayersLabel: UILabel!
    @IBOutlet weak var cancelHostingButton: UIButton!
    @IBOutlet weak var waitingView: UIView!
    
    
    var gamerSelected: GamerModel?
    var invitation: Invitation?
    var invitations = [Invitation]()
    var gameName: GameName?
    var gameTypeSelected: GameType!
    var rival: GamerModel? {
        didSet {
            setupSentUI()
        }
    }
    var parkSelected = String()
    //var multiPeerHelper = MultiPeerConnectivityHelper()
   
    //TO DO: Create a park
    var selectedInvitationOption: SelectedInvitationOption = .accepted
    
    private var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MultiPeerConnectivityHelper.shared.multipeerDelegate = self
        playButton.isEnabled = false
        activityIndicator.startAnimating()
        setupTap()
        sportLabel.text = gameName?.rawValue.capitalized
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if let gamer = gamerSelected {
//            bluePlayerLabel.text = gamer.username
//            bluePlayerImage.image = UIImage(named: gamer.username + "FightingRight")
//        }
       

    }
    
    func sendUserData(data: Data) {
        let action = MultiPeerConnectivityHelper.Action.sendUserInfo.rawValue
        let dataToSend = DataToSend(action: action, data: data)
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
        guard let role = MultiPeerConnectivityHelper.shared.role,
            let rival = rival else {return}
        switch role{
        case .Guest:
            bluePlayerLabel.text = TabBarViewController.currentUser.displayName
            bluePlayerImage.image = UIImage(named: TabBarViewController.currentUser.displayName! + "FightingRight")
            redPlayerLabel.text = rival.username
            redPlayerImage.image = UIImage(named: rival.username + "FightingLeft")
        case .Host:
            redPlayerLabel.text = TabBarViewController.currentUser.displayName
            redPlayerImage.image = UIImage(named: TabBarViewController.currentUser.displayName! + "FightingLeft")
            bluePlayerLabel.text = rival.username
            bluePlayerImage.image = UIImage(named: rival.username + "FightingRight")
        }
    }
//        DBService.fetchCurrentPlayer(gamerId: TabBarViewController.currentGamer.gamerID , completion: { (error, currentPlayer) in
//            if let error = error {
//                print(error)
//            }
//            if let currentPlayer = currentPlayer {
//
//            }
//        })
    
    @IBAction func cancelHostingPressed(_ sender: Any) {
        MultiPeerConnectivityHelper.shared.stopHosting()
        dismiss(animated: true)
    }
    

    @IBAction func playButtonPressed(_ sender: UIButton) {
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
    func createCurrentGameRoles(gameId: String) {
        let blueOnePlayer = CurrentPlayer(currentPlayerId: "", gamerId: gamerSelected!.gamerID, userName: gamerSelected!.username, teamRole: TeamRoles.blueOne.rawValue, gameId: gameId)
        DBService.postCurrentPlayer(currentPlayer: blueOnePlayer) { (error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        let redPlayerOne = CurrentPlayer(currentPlayerId: "",gamerId: TabBarViewController.currentUser.uid, userName: TabBarViewController.currentUser.displayName ?? "N/A", teamRole: TeamRoles.redOne.rawValue, gameId: gameId)
        DBService.postCurrentPlayer(currentPlayer: redPlayerOne) { (error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
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
    @objc func searchPlayerPressed() {
        let searchPlayerVc = SearchPlayerViewController.init(nibName: "SearchPlayerViewController", bundle: nil)
        searchPlayerVc.modalPresentationStyle = .fullScreen
        searchPlayerVc.searchDelegate = self
        searchPlayerVc.teamRole = .blueOne
        searchPlayerVc.gameType = .oneVsOne
        present(searchPlayerVc, animated: true)
        
    }
//    func presentAlertVC() {
//        let invitationAlertVC = InvitationAlertViewController.init(nibName: "InvitationAlertViewController", bundle: nil)
//        invitationAlertVC.invitation = invitations.first
//        invitationAlertVC.modalPresentationStyle = .overCurrentContext
//
//        present(invitationAlertVC, animated: true)
//    }
}

extension OneVsOneViewController: SearchForPlayerDelegate{
    func gamerSelected(gamer: GamerModel) {
        self.gamerSelected = gamer
    }
    
    
}
extension OneVsOneViewController: MultipeerConnectivityDelegate{
    func joinedGame() {
        
    }
    

    
    func receivedUserData(data: Data) {
        do {
            rival = try PropertyListDecoder().decode(GamerModel.self, from: data)
        
        }catch {
            print ("property list dedoding error:\(error)")
        }
        
    }
    
    func connected(to User: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.waitingView.isHidden = true
            self.playButton.isEnabled = true
            self.fetchAndSendUser()
        }
    }
    

    
    func acceptedInvitation() {

    }
    
    func invitePlayer(browser: MCNearbyServiceBrowser, peerID: MCPeerID, seesion: MCSession) {
        
    }
    
    func invitationNotification(handler: @escaping (Bool) -> Void) {
        invitationAlert(title: "Wants to join", message: "Accept?") { (action) in
            if action.title == "Yes" {
                handler(true)
            } else {
                handler(false)
            }
        }
    }
    

    
    func foundAdverstiser(availableGames: [String]) {
        
    }
    
    func displayAvailableGames(handler: @escaping (Bool) -> Void) {
        return
    }
    
    

    
    
}

