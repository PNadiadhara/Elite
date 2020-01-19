//
//  MessageBoardCell.swift
//  Elite
//
//  Created by Leandro Wauters on 1/16/20.
//  Copyright © 2020 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class MessageBoardCell: UITableViewCell {


    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        layer.borderWidth = 0.5
        backgroundColor = .yellow
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupCell(with message: MessageBoardPost, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        userNameLabel.text = message.posterName
        dateLabel.text = message.postDate
        messageLabel.text = message.post
    }
}
