//
//  FiveVsFiveFeedCell.swift
//  SelfSizingCellsTest
//
//  Created by Leandro Wauters on 4/7/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class FiveVsFiveFeedCell: UITableViewCell {


    @IBOutlet weak var sportImage: UIImageView!
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
