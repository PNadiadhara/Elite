//
//  LoadingScreenViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 6/23/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit


class LoadingScreenViewController: UIViewController, MultipeerConnectivityDelegate {
    func countIsTrue() {
        
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
        activityIndicator.stopAnimating()
        dismiss(animated: true)
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MultiPeerConnectivityHelper.shared.multipeerDelegate = self
        activityIndicator.startAnimating()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        MultiPeerConnectivityHelper.shared.stopHosting()
        presentingViewController?.dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
