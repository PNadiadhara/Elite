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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postImage.image = photoSelected
        titleTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, postImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.photoSelected = postImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }

    @IBAction func postPressed(_ sender: Any) {
        //TO DO: Store Image, and change post model
        let resizedImage = Toucan.init(image: photoSelected).resize(CGSize(width: 500, height: 500)).image
        guard let imageData = resizedImage?.jpegData(compressionQuality: 0.5) else {return}
        StorageService.postImage(imageData: imageData, imageName: <#T##String#>, completion: <#T##(Error?, URL?) -> Void#>)
        
    }
}
