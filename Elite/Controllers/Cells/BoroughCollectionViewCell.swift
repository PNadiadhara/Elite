//
//  BoroughCollectionViewCell.swift
//  Elite
//
//  Created by Leandro Wauters on 4/14/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class BoroughCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func layoutSubviews() {
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
}
