//
//  QrCodeViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 4/16/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class QrCodeViewController: UIViewController{
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateQRCodeOfUser(qrString: username.text, qrImage: qrCodeImage)
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension QrCodeViewController: CreateGameViewControllerDelegate {
    func generateQRCodeOfUser(qrString: String?, qrImage: UIImageView?) {
        if let usernameString = qrString {
            let data = usernameString.data(using: .ascii
                , allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "InputMessage")
            let ciImage = filter?.outputImage
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let transformImage = ciImage?.transformed(by: transform)
            let image = UIImage(ciImage: transformImage!)
            qrImage?.image = image
        }
    }
    
    
    
    
}
