//
//  FiveVsFiveViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class FiveVsFiveViewController: UIViewController {

    @IBOutlet weak var selectedSportLabel: UILabel!
    @IBOutlet weak var youButton: CircularRedButton!
    @IBOutlet weak var redPlayer1Button: CircularRedButton!
    @IBOutlet weak var redPlayer1Label: UILabel!
    @IBOutlet weak var redPlayer2Button: CircularRedButton!
    @IBOutlet weak var redPlayer2Label: UILabel!
    @IBOutlet weak var redPlayer4Button: CircularRedButton!
    @IBOutlet weak var redPlayer4Label: UILabel!
    @IBOutlet weak var redPlayer5Button: CircularRedButton!
    @IBOutlet weak var redPlayer5Label: UILabel!
    
    @IBOutlet weak var bluePlayer1Button: CircularBlueButton!
    @IBOutlet weak var bluePlayer1Label: UILabel!
    @IBOutlet weak var bluePlayer2Button: CircularBlueButton!
    @IBOutlet weak var bluePlayer2Label: UILabel!
    @IBOutlet weak var bluePlayer3Button: CircularBlueButton!
    @IBOutlet weak var bluePlayer3Label: UILabel!
    @IBOutlet weak var bluePlayer4Button: CircularBlueButton!
    @IBOutlet weak var bluePlayer4Label: UILabel!
    @IBOutlet weak var bluePlayer5Button: CircularBlueButton!
    @IBOutlet weak var bluePlayer5Label: UILabel!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func donePressed(_ sender: UIButton) {
    }
    


}
