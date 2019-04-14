//
//  OneVsOneViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class OneVsOneViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchPlayerView: versusLeft!
    @IBOutlet weak var bluePlayerImage: CircularBlueImageView!
    @IBOutlet weak var redPlayerImage: CircularRedImageView!
    @IBOutlet weak var redPlayerLabel: UILabel!
    @IBOutlet weak var bluePlayerLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTap()
    
        // Do any additional setup after loading the view.
    }
    @IBAction func playButtonPressed(_ sender: UIButton) {
        //To do: CREATE INSTANSE OF GAME
        let oneVsoneProgressVc = OneVsOneProgressViewController.init(nibName: "OneVsOneProgressViewController", bundle: nil)
        oneVsoneProgressVc.modalPresentationStyle = .fullScreen
        present(oneVsoneProgressVc, animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func setupTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchPlayerPressed))
        bluePlayerLabel.addGestureRecognizer(tap)
        bluePlayerImage.addGestureRecognizer(tap)
        bluePlayerImage.isUserInteractionEnabled = true
        bluePlayerLabel.isUserInteractionEnabled = true
    }

    @objc func searchPlayerPressed() {
        let searchPlayerVc = SearchPlayerViewController.init(nibName: "SearchPlayerViewController", bundle: nil)
        searchPlayerVc.modalPresentationStyle = .fullScreen
        present(searchPlayerVc, animated: true)
        
    }
}
