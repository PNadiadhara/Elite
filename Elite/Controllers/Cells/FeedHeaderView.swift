//
//  FeedHeaderView.swift
//  SelfSizingCellsTest
//
//  Created by Leandro Wauters on 4/5/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class FeedHeaderView: UIView {

    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.font = Constants.getHelveticaNeue(size: 40, type: "bold")
        label.text = "Label"
        label.textColor = .white
        return label
    }()
    
    lazy var cornerButton: UIButton = {
       var button = UIButton()
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1725490196, blue: 0.1843137255, alpha: 1)
        setupTitleLabel()
        setupCornerButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitleLabel() {
       addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
    }
    
    func setupCornerButton() {
        addSubview(cornerButton)
        cornerButton.translatesAutoresizingMaskIntoConstraints = false
        cornerButton.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        cornerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15).isActive = true
    }
    
    
}
