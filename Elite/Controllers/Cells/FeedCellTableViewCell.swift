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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var parkLabel: UILabel!
    
    @IBOutlet weak var sportImage: UIImageView!
    
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
