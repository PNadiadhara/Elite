//
//  PostPhotoViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 1/18/20.
//  Copyright © 2020 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Toucan

class PostPhotoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: TitleTextField!
    @IBOutlet weak var postImage: UIImageView!
    
    var photoSelected: UIImage!
    var parkId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        postImage.image = photoSelected
        titleTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, postImage: UIImage, parkId: String) {
        super.init(nibName: nil, bundle: nil)
        self.photoSelected = postImage
        self.parkId = parkId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }

    @IBAction func cancelPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func postPressed(_ sender: Any) {
        //TO DO: Store Image, and change post model
        guard let postTitle = titleTextField.text else {
            self.showAlert(title: "Please enter title", message: nil)
            return
        }
        let resizedImage = Toucan.init(image: photoSelected).resize(CGSize(width: 500, height: 500)).image
        guard let imageData = resizedImage?.jpegData(compressionQuality: 0.5) else {return}
        StorageService.postPostImage(imageData: imageData) { (error, url) in
            if let error = error {
                self.showAlert(title: "Error posting image", message: error.localizedDescription)
            }
            
            if let url = url {
                let messagePost = MessageBoardPost(parkId: self.parkId, post: postTitle , posterId: GamerModel.currentGamer.gamerID, postId: "", posterName: GamerModel.currentGamer.username ?? "", postDate: Date().toString(dateFormat: "MMM d, h:mm a"), postImage: url.absoluteString)
                DBService.postMessage(message: messagePost) { (error) in
                    if let error = error {
                        self.showAlert(title: "Error posting", message: error.localizedDescription)
                    } else {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
        
    }
}
