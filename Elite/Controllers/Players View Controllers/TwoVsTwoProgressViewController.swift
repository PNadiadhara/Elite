//
//  TwoVsTwoProgressViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 4/23/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class TwoVsTwoProgressViewController: UIViewController {
    @IBOutlet weak var redPlayerOneImage: CircularRedImageView!
    @IBOutlet weak var bluePlayerOneImage: CircularBlueImageView!
    @IBOutlet weak var bluePlayerTwoImage: CircularBlueImageView!
    @IBOutlet weak var redPlayerTwoImage: CircularRedImageView!
    @IBOutlet weak var redPlayerOneLabel: UILabel!
    
    @IBOutlet weak var redPlayerTwoLabel: UILabel!
    
    @IBOutlet weak var bluePlayerOneLabel: UILabel!
    @IBOutlet weak var bluePlayerTwoLabel: UILabel!
    @IBOutlet weak var sportSelectedLabel: UILabel!
    
    @IBOutlet weak var parkSelectedLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
