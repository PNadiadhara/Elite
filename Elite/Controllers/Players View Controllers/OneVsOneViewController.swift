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
    var gameName: String?
    var medalHelper = MedalsHelper()

    var waitingView: UIView?
 
//    var bluePlayer: GamerModel? {
//        didSet {
//            setupSentUI()
//        }
//    }
  
    //var multiPeerHelper = MultiPeerConnectivityHelper()
   
    //TO DO: Create a park
    var selectedInvitationOption: SelectedInvitationOption = .accepted
    private var rankingHelper = RankingHelper()
    private var listener: ListenerRegistration!
    
    var inviteResponse: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
//        let cgRect = CGRect(x: 0, y: 0, width: 207, height: 269)

        MultiPeerConnectivityHelper.shared.multipeerDelegate = self
        MultiPeerConnectivityHelper.shared.multipeerConnectivityPlayerWantsToJoinDelegate = self
        MultiPeerConnectivityHelper.shared.multipeerGameModelDelegate = self
        playButton.isEnabled = false
//        activityIndicator.startAnimating()
        sportLabel.text = gameName?.capitalized

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
        
            findPlayerRanking(players: [redPlayer, bluePlayer], sport: GameModel.gameName!)
        
    }

    func findPlayerRanking(players: [GamerModel],sport: String) {
        var count = 0
        for player in players {
            rankingHelper.findPlayerRanking(gamerId: player.gamerID, parkId: GameModel.parkId!, sport: sport) { (error, ranking) in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
                if let ranking = ranking {
                    if count == 0 {
                      self.redPlayerRanking.text = ranking.description
                        self.redPlayerMedalImage.image = self.medalHelper.getMedalImages(ranking: ranking)
                    } else {
                      self.bluePlayerRanking.text = ranking.description
                        self.bluePlayerMedal.image = self.medalHelper.getMedalImages(ranking: ranking)
                    }
                    
                }
                count += 1
            }
            
        }
//        setupSentUI()
    }
    @IBAction func playButtonPressed(_ sender: UIButton) {
        printValues()
        if MultiPeerConnectivityHelper.shared.role == .Host {
            
            GameModel.createGame(gameName: GameModel.gameName!, gameType: "1 vs. 1", redTeam: [MultiPeerConnectivityHelper.shared.redPlayer!.gamerID], blueTeam: [MultiPeerConnectivityHelper.shared.bluePlayer!.gamerID], parkId: GameModel.parkId ?? "", parkName: GameModel.parkSelected!, lat: GameModel.parkLat!, lon: GameModel.parkLon!, gameId: "", players: [MultiPeerConnectivityHelper.shared.redPlayer!.gamerID, MultiPeerConnectivityHelper.shared.bluePlayer!.gamerID])
        }
        
        let timerPopUp = TimerPopUp()
        self.navigationController?.pushViewController(timerPopUp, animated: true)
    }

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
    

    

    
    



}


extension OneVsOneViewController: MultipeerConnectivityPlayerWantsToJoinDelegate {
    func playerWantsToJoinGame(player: GamerModel, handler: @escaping (Bool) -> Void) {

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
        if MultiPeerConnectivityHelper.shared.role == .Host {
            let gameToSend = GameModelToSend(gameName: GameModel.gameName!, parkId: GameModel.parkId!, parkName: GameModel.parkSelected!)
            MultiPeerConnectivityHelper.shared.sendGameModel(game: gameToSend)
            setupSentUI()
        }
        
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
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension OneVsOneViewController: MultipeerConnectivityGameModelDelegate {
    func hostSentGame(data: Data) {
        MultiPeerConnectivityHelper.shared.decodeDataToGameSendModel(gameModelData: data)
        setupSentUI()
    }
    

}
