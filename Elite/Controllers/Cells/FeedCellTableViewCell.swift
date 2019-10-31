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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func setupView(){
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
    }

}
