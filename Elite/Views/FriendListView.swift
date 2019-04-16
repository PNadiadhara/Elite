//
//  FriendListView.swift
//  Elite
//
//  Created by Manny Yusuf on 4/12/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class FriendListView: UIView {

    lazy var friendListTableView: UITableView = {
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
        addSubview(friendListTableView)
        friendListTableView.translatesAutoresizingMaskIntoConstraints = false
        friendListTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        friendListTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        friendListTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        friendListTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}
