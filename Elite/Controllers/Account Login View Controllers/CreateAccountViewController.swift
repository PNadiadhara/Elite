//
//  CreateAccountViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Toucan

class CreateAccountViewController: UIViewController {
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    @IBOutlet weak var conteinerView: UIView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBOutlet weak var createNewUserBttn: SignInButton!
    @IBOutlet weak var userPhotoView: UIView!
    @IBOutlet weak var userPhoto: UIImageView!
    
    @IBOutlet weak var existingUserBttn: UIButton!
    private var authservice = AppDelegate.authservice
    private var snapchatHelper = SnapchatHelper()
    
    
    var keyboardHeight = CGFloat()
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        setOutletsDelegates()
        setViewControllerSettings()
        setupTap()
        setupUserPhotoView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotifications()
    }
    
    private func setOutletsDelegates(){
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func setViewControllerSettings(){
        setupTap()
        authservice.authserviceCreateNewAccountDelegate = self
        snapchatHelper.delegate = self
        existingUserBttn.layer.cornerRadius = 5
    }

    func setupUserPhotoView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(photoViewTapped))
        userPhotoView.addGestureRecognizer(tap)
    }
    
    @objc private func photoViewTapped() {
        showImagesSourceOptionsForCreatingUser(imagePickerController: imagePickerController)
    }
    
    private func createNewUser(){
        
        guard let userPhoto = selectedImage else {
            showAlert(title: "Please Select Photo", message: nil)
            
            return
        }
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            let username = usernameTextField.text,
            !email.isEmpty,
            !confirmPassword.isEmpty,
            !password.isEmpty,
            !username.isEmpty
            else {
                showAlert(title: "Missing Required Fields", message: "Email and Password Required")
                return
        }
        if password != confirmPassword {
            showAlert(title: "Passwords do not match", message: "Try again")
        } else {
            activityIndicator.startAnimating()
            authservice.createNewAccount(email: email, password: password, username: username, userImage: userPhoto)
        }
        
    }
    
    private func goBackToPreviousVC(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        createNewUser()
    }
    
    @IBAction func existingUserBttnPressed(_ sender: UIButton){
        goBackToPreviousVC()
    }
    

    @IBAction func showLoginView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension CreateAccountViewController : AuthServiceCreateNewAccountDelegate {
    func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription)
    }
    
    func didCreateNewAccount(_ authservice: AuthService, user gamer: GamerModel) {
        segueToLoadingScreen(gamerId: gamer.gamerID)
    }
    
}
extension CreateAccountViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension CreateAccountViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        userPhoto.image = resizedUserImage
        dismiss(animated: true)
    }
}

extension CreateAccountViewController: SnapchatDelegate {
    func snapchatAvatarFound() {
        
    }
    
    func showImagesSourceOptionsForCreatingUser(imagePickerController: UIImagePickerController) {
        
        showSheetAlert(title: "Please select option", message: nil) { (alertController) in
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true)
            })
            let photoLibaryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true)
            })
            
            let snapchatPhoto = UIAlertAction(title: "Snapchat", style: .default) { (action) in
                self.snapchatHelper.getSnapchatAvatar(viewController: self)
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alertController.addAction(cameraAction)
                alertController.addAction(photoLibaryAction)
                alertController.addAction(snapchatPhoto)
            } else {
                alertController.addAction(photoLibaryAction)
                alertController.addAction(snapchatPhoto)
            }
        }
    }
}
