//
//  TimerPopUp.swift
//  Elite
//
//  Created by Leandro Wauters on 6/23/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit




class TimerPopUp: UIViewController {

    
    @IBOutlet weak var redPlayerImage: CircularRedImageView!
    @IBOutlet weak var bluePlayerImage: CircularBlueImageView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var doneButton: RoundedButton!
    @IBOutlet weak var pauseButton: RoundedButton!
    @IBOutlet weak var cancelButton: RoundedButton!
    
    @IBOutlet weak var redPlayerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bluePlayerActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var readyView: UIView!
    
    @IBOutlet weak var readyButton: RoundedButton!
    
    @IBOutlet weak var waitingForPlayerLabel: UILabel!
    @IBOutlet weak var waitingForPlayersActivityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupUI()
        setupBackgroundNotifications()

    }
    
    private func setupUI() {
        waitingForPlayersActivityIndicator.stopAnimating()
        redPlayerActivityIndicator.stopAnimating()
        bluePlayerActivityIndicator.stopAnimating()
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 65, weight: .light)
    }
    
    private func setupBackgroundNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(pauseTimer), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startApp) , name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func setupDelegates() {
        MainTimer.shared.delegate = self
        MultiPeerConnectivityHelper.shared.timerDelegate = self
        MultiPeerConnectivityHelper.shared.multipeerDelegate = self
    }
    @objc func pauseTimer() {
        MainTimer.shared.pauseTime()
    }
    @objc func startApp(){
        MainTimer.shared.restartTimer()
    }
    
    func segueToEndGameVc(){
        let endGameVc = EndGameViewController()
        self.present(endGameVc, animated: true)
    }
    private func sendJoinConfirmation() {
        MultiPeerConnectivityHelper.shared.numberOfPlayersJoined += 1
        let action = MultiPeerConnectivityHelper.Action.joinedGame.rawValue
        let dataToSend = DataToSend(action: action, data: nil)
        MultiPeerConnectivityHelper.shared.convertDataToSendToDataAndSend(dataToSend: dataToSend)
    }
    

    
    @IBAction func readyButtonPressed(_ sender: Any) {
        readyButton.isHidden = true
        waitingForPlayerLabel.isHidden = false
        sendJoinConfirmation()
        waitingForPlayersActivityIndicator.isHidden = false
        waitingForPlayersActivityIndicator.startAnimating()
        
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        confirmAlert(title: "Finish Game", message: "Are you sure?") { (done) in
            self.segueToEndGameVc()
            let action = MultiPeerConnectivityHelper.Action.finishedGame.rawValue
            let dataToSend = DataToSend(action: action, data: nil)
            MultiPeerConnectivityHelper.shared.convertDataToSendToDataAndSend(dataToSend: dataToSend)
        }
    }
    @IBAction func pauseButtonPressed(_ sender: Any) {
        
        switch MultiPeerConnectivityHelper.shared.buttonStatus {
        case .Pause:
            pauseButton.setTitle("Play", for: .normal)
            let pauseSharedTimerAction = MultiPeerConnectivityHelper.Action.pauseSharedTimer.rawValue
            MainTimer.shared.timerManager(action: pauseSharedTimerAction)
            MainTimer.shared.suspend()
            MultiPeerConnectivityHelper.shared.buttonStatus = MultiPeerConnectivityHelper.ButtonStatus.Play
        case .Play:
            pauseButton.setTitle("Pause", for: .normal)
            let resumeSharedTimerAction = MultiPeerConnectivityHelper.Action.resumeSharedTimer.rawValue
            MainTimer.shared.timerManager(action: resumeSharedTimerAction)
            MainTimer.shared.resume()
            MultiPeerConnectivityHelper.shared.buttonStatus = MultiPeerConnectivityHelper.ButtonStatus.Pause
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
    }
    
    

}
extension TimerPopUp: MultipeerConnectivityDelegate{
    func joinedGame() {
        readyView.isHidden = true
        if MultiPeerConnectivityHelper.shared.team == .RedPlayer {
            MainTimer.shared.runTimer()
            let startSharedTimerAction = MultiPeerConnectivityHelper.Action.startedTimer.rawValue
            MainTimer.shared.timerManager(action: startSharedTimerAction)
        }
    }
    

    func acceptedInvitation() {
        
    }
    
    func receivedUserData(data: Data) {

    }
    
    func foundAdverstiser(availableGames: [String]) {
        
    }
    
    func invitationNotification(handler: @escaping (Bool) -> Void) {
        
    }
    
    func connected(to User: String) {
        
    }
    
    
}

extension TimerPopUp: TimerDelegate {
    func finishedTimer() {
        segueToEndGameVc()
    }
    
    func changedButtonText(text: String) {
        pauseButton.setTitle(text, for: .normal)
    }
    
    
    func sharedTimer(time: String) {
        DispatchQueue.main.async {
            self.timerLabel.text = time
        }
    }
}
//extension TimerPopUp: CountdownDelegate {
//    func timerFinished() {
//        readyView.isHidden = true
//    }
//
//    func timerIsRunning(time: String) {
//
//    }
//
//
//}
