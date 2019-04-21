//
//  MapViewPopupController.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/19/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class MapViewPopupController: UIViewController {
    //MARK: - Outlets and Properties
    @IBOutlet weak var nameOfPark: UILabel!
    
    @IBOutlet weak var parkAddress: UILabel!
    var basketballReults: BasketBall!
    var handballResults: HandBall!
    override func viewDidLoad() {
        super.viewDidLoad()
//        displayHandBallInfo()
//        displayBasketBallInfo()
    }
    
    private func displayHandBallInfo(){
        nameOfPark.text = handballResults.nameOfPlayground ?? "No Name"
        parkAddress.text = handballResults.location ?? "No Address"
    }
    
    private func displayBasketBallInfo(){
        nameOfPark.text = basketballReults.nameOfPlayground ?? "No Name"
       parkAddress.text = basketballReults.location ?? "No Address"
    }
    // if the marker on google maps is of type basketball load the markers information based on the marker information realted to basketball and vice versa for handball
    
    //MARK: - Actions
    @IBAction func bringDownView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gotToParkFeed(_ sender: UIButton) {
    }
    
    @IBAction func goToLeaderBaord(_ sender: UIButton) {
    }
    
}
