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
    
    override func viewWillAppear(_ animated: Bool) {
        registerKeyboardNotificationForBottomView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterKeyboardNotifications()
    }

    private func registerKeyboardNotificationForBottomView(){
        NotificationCenter.default.addObserver(self, selector: #selector(willTransfromBottomView(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func willTransfromBottomView(notification: Notification){
        doneButton.isHidden = false
        guard let info = notification.userInfo,
            let keyboardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
                print("UserInfo is nil")
                return
        }
        
        bottomView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
    }
    
    @objc private func willHideKeyboard() {
       bottomView.transform = CGAffineTransform.identity
        doneButton.isHidden = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        characterCountLabel.text = (280 - textView.text.count).description
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 280
    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}


