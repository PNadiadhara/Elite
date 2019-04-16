//
//  OneVsOneViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Firebase
protocol SearchForPlayerDelegate: AnyObject {
    func gamerSelected(gamer: GamerModel)
    func invitationCreated(invitation: Invitation)
}
class OneVsOneViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchPlayerView: versusLeft!
    @IBOutlet weak var bluePlayerImage: CircularBlueImageView!
    @IBOutlet weak var redPlayerImage: CircularRedImageView!
    @IBOutlet weak var redPlayerLabel: UILabel!
    @IBOutlet weak var bluePlayerLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addPlayerView: UIView!
    
    
    var gamerSelected: GamerModel?
    var invitation: Invitation?
    var invitations = [Invitation]()
    private var listener: ListenerRegistration!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTap()
        fetchInvitationRequest()
    
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if let gamer = gamerSelected {
            bluePlayerLabel.text = gamer.username
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
        //To do: CREATE INSTANSE OF GAME
        let oneVsoneProgressVc = OneVsOneProgressViewController.init(nibName: "OneVsOneProgressViewController", bundle: nil)
        oneVsoneProgressVc.modalPresentationStyle = .fullScreen

        present(oneVsoneProgressVc, animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func setupTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchPlayerPressed))
        addPlayerView.addGestureRecognizer(tap)
    }

    @objc func fetchInvitationRequest() {
        guard let user = AppDelegate.authservice.getCurrentUser() else {return}
        listener = DBService.firestoreDB.collection(InvitationCollectionKeys.collectionKey).whereField("reciever", isEqualTo: user.uid)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    self?.showAlert(title: "Error fetching blogs", message: error.localizedDescription)
                } else if let snapshot = snapshot {
                    print("Invitation recieved")
                    self?.invitations = snapshot.documents.map {Invitation.init(dict: $0.data())}
                    if (self?.invitations.count)! > 0 {
                        self?.confirmAlert(title: "\(self?.invitations.first?.sender ?? "NA") sent you and invitation", message: "Accept?", handler: { (action) in
                            switch action.title {
                            case "Yes":
                                let oneVsoneProgressVc = OneVsOneProgressViewController.init(nibName: "OneVsOneProgressViewController", bundle: nil)
                                oneVsoneProgressVc.modalPresentationStyle = .fullScreen
                                
                                oneVsoneProgressVc.invitation = self?.invitations.first
                                DBService.updateInvitationApprovalToTrue(completion: { (error) in
                                    if let error = error {
                                        self?.showAlert(title: "Error", message: error.localizedDescription)
                                    } else {
                                        print("Invitation accepted")
                                    }
                                })
                                self?.present(oneVsoneProgressVc, animated: true)
                            case "No":
                                DBService.deleteInvitation(invitation: (self?.invitations.first)!, completion: { (error) in
                                    if let error = error{
                                        print(error.localizedDescription)
                                    }
                                })
                            default:
                                return
                            }

                        })
                        
                    }
                }
        }
    }
    @objc func searchPlayerPressed() {
        let searchPlayerVc = SearchPlayerViewController.init(nibName: "SearchPlayerViewController", bundle: nil)
        searchPlayerVc.modalPresentationStyle = .fullScreen
        searchPlayerVc.searchDelegate = self
        present(searchPlayerVc, animated: true)
        
    }
}

extension OneVsOneViewController: SearchForPlayerDelegate{
    func invitationCreated(invitation: Invitation) {
        self.invitation = invitation
    }
    
    func gamerSelected(gamer: GamerModel) {
        self.gamerSelected = gamer
    }
    
    
}
