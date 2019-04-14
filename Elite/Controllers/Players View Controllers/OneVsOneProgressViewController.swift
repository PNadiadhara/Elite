//
//  OneVsOneProggressViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 4/13/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class OneVsOneProgressViewController: UIViewController {

    var timer = MainTimer(timeInterval: 0.0001)
    var buttons = [UIButton]()
    
    @IBOutlet weak var sportParkLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var redTeamImage: CircularRedImageView!
    @IBOutlet weak var redTeamLabel: UILabel!
    @IBOutlet weak var blueTeamImage: CircularBlueImageView!
    @IBOutlet weak var blueTeamLabel: UILabel!
    @IBOutlet weak var cancelButton: RoundedButton!
    @IBOutlet weak var pauseButton: RoundedButton!
    @IBOutlet weak var endButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(pauseTimer), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startApp) , name: UIApplication.didBecomeActiveNotification, object: nil)
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 50, weight: .regular)
        buttons = [cancelButton, pauseButton, endButton]
        buttons.forEach{$0.isEnabled = false}
        buttons.forEach{$0.alpha = 0.5}
    }

    func runTimer (){
        timer.eventHandler = {
            MainTimer.time += 0.0001
            self.action()
        }
        timer.resume()
    }
    @objc func pauseTimer() {
        timer.pauseTime()
    }
    @objc func startApp(){
        timer.restartTimer()
    }
    @IBAction func startButtonPressed(_ sender: UIButton) {
        sender.isHidden = true
        buttons.forEach{$0.isEnabled = true}
        buttons.forEach{$0.alpha = 1}
        runTimer()
    }
    
    @IBAction func pausePressed(_ sender: UIButton) {
        switch timer.state {
        case .resumed:
            timer.suspend()
            sender.setTitle("Resume", for: .normal)
        case .suspended:
            timer.resume()
            sender.setTitle("Pause", for: .normal)
        default:
            return
        }
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        confirmActionSheet(title: "Game Cancel", message: "Are you sure?") { (action) in
            let tab = TabBarViewController.setTabBarVC()
            self.present(tab, animated: true)
        }
    }
    @IBAction func endPressed(_ sender: Any) {
    }
    
    @objc func action() {
        DispatchQueue.main.async {
            self.timerLabel.text = MainTimer.timeStringWithMilSec(time: TimeInterval(MainTimer.time))
        }
    }
}
