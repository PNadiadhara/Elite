//
//  AlertViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 7/16/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var countdownTimer = Timer()
    var time = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
//       startTimer()
        // Do any additional setup after loading the view.
    }

    init(time : Int) {
        super.init(nibName: nil, bundle: nil)
        self.time = time
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
