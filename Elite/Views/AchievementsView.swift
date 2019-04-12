//
//  AchievementsView.swift
//  Elite
//
//  Created by Manny Yusuf on 4/12/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class AchievementsView: UIView {
    lazy var achievementsTableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView(){
        addSubview(achievementsTableView)
        achievementsTableView.translatesAutoresizingMaskIntoConstraints = false
        achievementsTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        achievementsTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        achievementsTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        achievementsTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
  

    
}
