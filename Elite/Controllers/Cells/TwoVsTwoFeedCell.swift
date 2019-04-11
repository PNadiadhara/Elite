//
//  2vs2FeedTableViewCell.swift
//  SelfSizingCellsTest
//
//  Created by Leandro Wauters on 4/7/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class TwoVsTwoFeedCell: UITableViewCell {

    @IBOutlet weak var user1TeamA: UIImageView!
    @IBOutlet weak var user2TeamA: UIImageView!
    @IBOutlet weak var user1TeamB: UIImageView!
    @IBOutlet weak var user2TeamB: UIImageView!
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    
    
    @IBOutlet weak var view: UIView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }

    func setupView(){
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
    }

}
