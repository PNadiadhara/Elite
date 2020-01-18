//
//  PostMessageViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 1/15/20.
//  Copyright © 2020 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class PostMessageViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var parkLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    var parkId: String!
    var parkName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        parkLabel.text = parkName
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, parkId: String, parkName: String) {
        self.parkId = parkId
        self.parkName = parkName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBAction func postPressed(_ sender: Any) {
        if textField.text.isEmpty {
            showAlert(title: "Empty text", message: "Please enter message")
        } else {
            let message = MessageBoardPost(parkId: parkId, post: textField.text, posterId: GamerModel.currentGamer.gamerID, postId: "", posterName: GamerModel.currentGamer.username ?? "", postDate: Date())
            DBService.postMessage(message: message) { (error) in
                if let error = error {
                    self.showAlert(title: "Error posting", message: error.localizedDescription)
                } else {
                    self.dismiss(animated: true)
                }
            }
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message here"
            textView.textColor = UIColor.lightGray
        }
    }
}


