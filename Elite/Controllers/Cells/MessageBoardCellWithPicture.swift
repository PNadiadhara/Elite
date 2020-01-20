//
//  MessageBoardCellWithPicture.swift
//  Elite
//
//  Created by Leandro Wauters on 1/19/20.
//  Copyright © 2020 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import Kingfisher
class MessageBoardCellWithPicture: UITableViewCell {

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postUserAndDateLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setupCell(with message: MessageBoardPost) {
        guard let url = URL(string: message.postImage!) else {
            return
        }
        postImage.kf.setImage(with: url)
        postUserAndDateLabel.text = "\(message.posterName) - \(message.postDate)"
        postTitleLabel.text = message.post
    }
}
