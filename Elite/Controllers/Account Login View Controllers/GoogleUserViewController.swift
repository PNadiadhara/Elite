//
//  GoogleUserViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 1/21/20.
//  Copyright © 2020 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Firebase
import Toucan

class GoogleUserViewController: UIViewController {


    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    @IBOutlet weak var addPhotoView: AddPhotoView!
    
    @IBOutlet weak var activityIndcator: UIActivityIndicatorView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var selectedImage: UIImage?
    var user: User!
    private var authservice = AppDelegate.authservice
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        authservice.authserviceCreateNewAccountDelegate = self
        setupTap()
        setupUserPhotoView()
        // Do any additional setup after loading the view.
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUserPhotoView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(photoViewTapped))
        addPhotoView.addGestureRecognizer(tap)
    }
    
    @objc private func photoViewTapped() {
        showImagesSourceOptions(imagePickerController: imagePickerController)
    }
    private func createAccout() {
        guard let userPhoto = selectedImage else {
            showAlert(title: "Please Select Photo", message: nil)
            return
        }
        guard let username = usernameTextField.text,
            !username.isEmpty else {
                showAlert(title: "Please enter username", message: nil)
                return
        }
        activityIndcator.startAnimating()
        authservice.createGoogleAccount(userId: user.uid, email: user.email! , username: username, userImage: userPhoto)
        
    }
    
    @IBAction func createPressed(_ sender: Any) {
        createAccout()
    }
    
}

extension GoogleUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension GoogleUserViewController : AuthServiceCreateNewAccountDelegate {
    func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription)
    }
    
    func didCreateNewAccount(_ authservice: AuthService, user gamer: GamerModel) {
        segueToLoadingScreen(gamerId: gamer.gamerID)
    }
    
}

extension GoogleUserViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("original image is nil")
            return
        }
        guard let resizedUserImage = Toucan.init(image: originalImage).resize(CGSize(width: 500, height: 500)).image else {
            showAlert(title: "Error resizing image", message: nil)
            return
        }
        selectedImage = resizedUserImage
        userImage.image = resizedUserImage
        dismiss(animated: true)
    }
}
