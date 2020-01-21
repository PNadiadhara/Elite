//
//  OptionsViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 11/1/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

protocol OptionsViewDelegate: AnyObject {
    func leaderboardPressed()
    func playPressed()
}
class OptionsViewController: UIViewController {

    weak var delegate: OptionsViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func leaderboardPressed(_ sender: Any) {
        delegate?.leaderboardPressed()
    }
    
    @IBAction func playPressed(_ sender: Any) {
        delegate?.playPressed()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
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
