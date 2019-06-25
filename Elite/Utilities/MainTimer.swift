//
//  Timer.swift
//  Elite
//
//  Created by Leandro Wauters on 4/13/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
class MainTimer {
    
    let timeInterval: TimeInterval
    static var time = 0.0
    static var totalTime = 0.0
    
    
    var currentBackgroundDate = NSDate()
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    var eventHandler: (() -> Void)?
    
    enum State {
        case suspended
        case resumed
        case restated
    }
    
    var state: State = .suspended
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
    
    func restartTimer(){
        if state == .suspended{
            return
        }
        let difference = self.currentBackgroundDate.timeIntervalSince(NSDate() as Date)
        let timeSince = abs(difference)
        MainTimer.time += timeSince
        timer.resume()
    }
    func pauseTime(){
        if state == .suspended {
            return
        }
        timer.suspend()
        currentBackgroundDate = NSDate()
    }
    

    

    static func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    static func getTimeInString(time: Double) -> String {
        guard !(time.isNaN || time.isInfinite) else {
            return "00:00:00"
        }
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    static func timeStringWithMilSec(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let milliseconds = Int(((time.truncatingRemainder(dividingBy: 1)) * 1000) / 10)
        return String(format: "%02i:%02i:%0.2i", minutes, seconds, milliseconds)
    }
}

//protocol CountdownDelegate: AnyObject {
//    func timerIsRunning(time: String)
//    func timerFinished()
//}
//
//class CountdownTimer {
//    
//    var countdownTimer: Timer!
//    weak var delegate: CountdownDelegate!
//    
//    var countdownTotalTime = 5 {
//        didSet {
//            delegate.timerIsRunning(time: countdownTotalTime.description)
//        }
//    }
//    
//    static var share = CountdownTimer()
//    func startTimerCountdown() {
//        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
//    }
//    
//    @objc func updateTime() {
//        if countdownTotalTime != 1 {
//            countdownTotalTime -= 1
//        } else {
//            endTimer()
//            delegate.timerFinished()
//        }
//    }
//    
//    func endTimer() {
//        countdownTimer.invalidate()
//    }
//    
//
//}
