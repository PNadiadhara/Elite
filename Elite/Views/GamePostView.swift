//
//  GamePostView.swift
//  Elite
//
//  Created by Manny Yusuf on 4/12/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class GamePostView: UIView {
    lazy var gamePostTableView: UITableView = {
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
        addSubview(gamePostTableView)
        gamePostTableView.translatesAutoresizingMaskIntoConstraints = false
        gamePostTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
                gamePostTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                gamePostTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                gamePostTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}
