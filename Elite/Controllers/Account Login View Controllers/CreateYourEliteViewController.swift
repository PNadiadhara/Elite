//
//  CreateYourEliteViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 7/13/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Toucan
import Kingfisher
class CreateYourEliteViewController: UIViewController {
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    
    
    private var authservice = AppDelegate.authservice
    
    @IBOutlet weak var userView: CircularRedView!
    
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: RoundedTextField!
    
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewTap()
        setupTap()
        userNameTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotifications()
    }
    
    func setupViewTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(addPhotoPressed))
        userView.addGestureRecognizer(tap)
    }


    @objc func addPhotoPressed(_ sender: Any) {
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
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let selectedImage = selectedImage else {
            showAlert(title: "Plase select image", message: nil)
            return
        }
        guard let userName = userNameTextField.text else {
            showAlert(title: "Plase select username", message: nil)
            return
        }
        guard let userProfileImageData = selectedImage.jpegData(compressionQuality: 0.5) else {return}
        if let user = AppDelegate.authservice.getCurrentUser() {
            StorageService.postImage(imageData: userProfileImageData, imageName: user.uid) { (error, url) in
                if let error = error {
                    self.showAlert(title: "Error updating profile image", message: error.localizedDescription)
                }
                if let url = url {
                    self.authservice.updateUserProfile(user: user, username: userName)
                    DBService.updateUserProfileImage(userId: user.uid, imageUrl: url.absoluteString)
                    let loadingScreen = LoadingViewController(nibName: nil, bundle: nil, gamerID: user.uid)
                    self.present(loadingScreen, animated: true)
                }
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
extension CreateYourEliteViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
extension CreateYourEliteViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("original image is nil")
            return
        }
        let resizedImage = Toucan.init(image: originalImage).resize(CGSize(width: 500, height: 500))
        selectedImage = resizedImage.image
        userView.backgroundColor = UIColor(patternImage: selectedImage!)
        addPhotoLabel.isHidden = true
        dismiss(animated: true)
    }
}
