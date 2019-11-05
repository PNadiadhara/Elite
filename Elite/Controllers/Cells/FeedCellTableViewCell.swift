//
//  FeedCellTableViewCell.swift
//  SelfSizingCellsTest
//
//  Created by Leandro Wauters on 4/5/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var user1Image: UIImageView!
    @IBOutlet weak var redPlayerLabel: UILabel!
    @IBOutlet weak var bluePlayerLabel: UILabel!
    
    @IBOutlet weak var gameTimeLabel: UILabel!
    
    @IBOutlet weak var user2Image: UIImageView!
    @IBOutlet weak var sportAndParkLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func setupView(){
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.layer.borderWidth = 0.5
    }

}
