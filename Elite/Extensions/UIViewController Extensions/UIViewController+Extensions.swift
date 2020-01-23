//
//  UIViewController+Extensions.swift
//  Elite
//
//  Created by Leandro Wauters on 10/27/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import UIKit
import SAConfettiView
extension UIViewController {
    
    
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setupTap() {
        let screenTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    }
    

    func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc private func willHideKeyboard(){
        view.transform = CGAffineTransform.identity
    }
    
    @objc private func willShowKeyboard(notification: Notification){
        guard let info = notification.userInfo,
            let keyboardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
                print("UserInfo is nil")
                return
        }
        
        view.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 150)
    }
    
    func setupBackgroundNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(pauseTimer), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startApp) , name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    

    @objc func pauseTimer() {
        guard let isPause = MainTimer.shared.isPause else {
           MainTimer.shared.pauseTime()
            return
        }
        if !isPause{
            MainTimer.shared.pauseTime()
        }
    }
    @objc func startApp(){
        guard let isPause = MainTimer.shared.isPause else {
            MainTimer.shared.restartTimer()
            return
        }
        if !isPause{
            MainTimer.shared.restartTimer()
        }
    }
    
    func stopTimer() {
        MainTimer.shared.stopTimer()
        print("Timer Spoted")
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    func setupConfetti(confettiView: SAConfettiView, intensity: Float){
        self.view.addSubview(confettiView)
        view.sendSubviewToBack(confettiView)
        confettiView.type = .Confetti
        confettiView.intensity = intensity
    }
    
    func segueToLoadingScreen(gamerId: String) {
        let loadingScreen = LoadingViewController(nibName: nil, bundle: nil, gamerID: gamerId)
        navigationController?.pushViewController(loadingScreen, animated: true)
    }
    func showImagesSourceOptions(imagePickerController: UIImagePickerController) {
        
        showSheetAlert(title: "Please select option", message: nil) { (alertController) in
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true)
            })
            let photoLibaryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true)
            })
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alertController.addAction(cameraAction)
                alertController.addAction(photoLibaryAction)
            } else {
                alertController.addAction(photoLibaryAction)
            }
        }
    }
}
