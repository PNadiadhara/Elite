//
//  TwoVsTwoViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

protocol twoVsTwoSearchDelegate: AnyObject {
    func redTwoPlayer(redTwoPlayer: GamerModel?)
    func blueOnePlayer(blueOnePlayer: GamerModel?)
    func blueTwoPlayer(blueTwoPlayer: GamerModel?)
}
class TwoVsTwoViewController: UIViewController {

    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var redPlayerOneImage: UIImageView!
    @IBOutlet weak var redPlayerOneLabel: UILabel!
    @IBOutlet weak var redPlayerTwoImage: UIImageView!
    @IBOutlet weak var redPlayerTwoLabel: UILabel!
    @IBOutlet weak var bluePlayerOneImage: UIImageView!
    @IBOutlet weak var bluePlayerOneLabel: UILabel!
    @IBOutlet weak var bluePlayerTwoImage: UIImageView!
    @IBOutlet weak var bluePlayerTwoLabel: UILabel!
    @IBOutlet weak var redPlayerTwoButton: UIButton!
    @IBOutlet weak var bluePlayerOneButton: UIButton!
    @IBOutlet weak var bluePlayerTwoButton: UIButton!
    
    
    
    
    
    
    
    
}
