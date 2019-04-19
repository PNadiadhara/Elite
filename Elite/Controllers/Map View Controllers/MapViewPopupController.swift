//
//  MapViewPopupController.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/19/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class MapViewPopupController: UIViewController {
    //MARK: - Outlets and Properties
    @IBOutlet weak var nameOfPark: UILabel!
    
    @IBOutlet weak var parkAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    //MARK: - Actions
    @IBAction func bringDownView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gotToParkFeed(_ sender: UIButton) {
    }
    
    @IBAction func goToLeaderBaord(_ sender: UIButton) {
    }
    
}
