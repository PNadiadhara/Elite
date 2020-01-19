//
//  ParkFeedViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 11/8/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

enum ParkFeedView {
    case recentActivity, messageBoard
}
class ParkFeedViewController: UIViewController {

    var parkId: String!
    var parkName: String!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var recentActivityButton: RoundedButton!
    @IBOutlet weak var messageBoardButton: RoundedButton!
    @IBOutlet weak var postCommentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cameraButton: UIButton!
    
    private var parkViewFeed: ParkFeedView! {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var parkActivity = [GameModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var messageBoardPosts = [MessageBoardPost]()

    override func viewDidLoad() {
        super.viewDidLoad()
        parkNameLabel.text = parkName
        parkViewFeed = .recentActivity
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RecentActivityCell", bundle: nil), forCellReuseIdentifier: "RecentActivityCell")
        tableView.register(UINib(nibName: "MessageBoardCell", bundle: nil), forCellReuseIdentifier: "MessageBoardCell")
        fetchParkGames()
        fetchBoardMessages()
        setupTapGestures()
        // Do any additional setup after loading the view.
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, parkId: String, parkName: String) {
        self.parkName = parkName
        self.parkId = parkId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTapGestures() {
        let postMessageGesture = UITapGestureRecognizer(target: self, action: #selector(showMassageBoardText))
        postCommentView.addGestureRecognizer(postMessageGesture)
        
    }
    
    @objc func showMassageBoardText() {
        let postMessageVC = PostMessageViewController(nibName: nil, bundle: nil, parkId: parkId, parkName: parkName)
        present(postMessageVC, animated: true, completion: nil)
    }
    
    private func setupButtonColors() {
        switch parkViewFeed {
        case .recentActivity:
            recentActivityButton.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.737254902, alpha: 1)
            recentActivityButton.setTitleColor(.white, for: .normal)
            messageBoardButton.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1725490196, blue: 0.1843137255, alpha: 1)
            messageBoardButton.setTitleColor(#colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1), for: .normal)
            postCommentView.isHidden = true
        case .messageBoard:
            messageBoardButton.backgroundColor = #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1)
            messageBoardButton.setTitleColor(.white, for: .normal)
            recentActivityButton.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1725490196, blue: 0.1843137255, alpha: 1)
            recentActivityButton.setTitleColor(#colorLiteral(red: 0, green: 0.4980392157, blue: 0.737254902, alpha: 1), for: .normal)
            postCommentView.isHidden = false
        default:
            print("Error")
        }
    }
    private func fetchParkGames() {
        DBService.fetchGamesPlayedAtPark(parkId: parkId) { (error, gamesAtPark) in
            if let error = error {
                self.showAlert(title: "Error fetching parks", message: error.localizedDescription)
            }
            if let gamesAtPark = gamesAtPark {
                self.parkActivity = gamesAtPark.sorted{$0.gameEndTime!.stringToDate() > $1.gameEndTime!.stringToDate()}
            }
        }
    }
    
    private func fetchBoardMessages() {
        DBService.fetchMessageBoardWithParkId(parkId: parkId) { (error, boardMessages) in
            if let error = error {
                self.showAlert(title: "Error fetching board messages", message: error.localizedDescription)
            }
            if let boardMessages = boardMessages {
                self.messageBoardPosts = boardMessages
            }
        }
    }
    @IBAction func recentActivityPressed(_ sender: Any) {
        parkViewFeed = .recentActivity
        setupButtonColors()
    }
    
    @IBAction func messageBoardPressed(_ sender: Any) {
        parkViewFeed = .messageBoard
        setupButtonColors()
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        showSheetAlert(title: "Please select option", message: nil) { (alertController) in
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true)
            })
            let photoLibaryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true)
            })
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alertController.addAction(cameraAction)
                alertController.addAction(photoLibaryAction)
            } else {
                alertController.addAction(photoLibaryAction)
            }
        }
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

extension ParkFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch parkViewFeed {
        case .recentActivity:
            return parkActivity.count
        case .messageBoard:
            return messageBoardPosts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch parkViewFeed {
        case .recentActivity:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentActivityCell", for: indexPath) as? RecentActivityCell else {fatalError()}
            let activity = parkActivity[indexPath.row]
            cell.setupCell(with: activity)
            return cell
        case .messageBoard:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageBoardCell", for: indexPath) as? MessageBoardCell else {fatalError()}
            let message = messageBoardPosts[indexPath.row]
            cell.setupCell(with: message)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch parkViewFeed {
        case .recentActivity:
            return 180
        case .messageBoard:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        switch parkViewFeed {
            case .recentActivity:
                return 180
            case .messageBoard:
                return UITableView.automaticDimension
            default:
                return 0
            }
     }
    
}

extension ParkFeedViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("original image is nil")
            return
        }
        
//        let resizedImage = Toucan.init(image: originalImage).resize(CGSize(width: 175, height: 175))
    let postPhotoVC = PostPhotoViewController(nibName: nil, bundle: nil, postImage: originalImage)
        dismiss(animated: true)
        present(postPhotoVC, animated: true)
    }
}
