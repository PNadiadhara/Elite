//
//  MapViewPopupController.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/19/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
protocol MapViewPopupControllerDelegate: AnyObject {
    func getMilesFromUser(miles: String)
}
class MapViewPopupController: UIViewController {
    //MARK: - Outlets and Properties
    var basketballReults: BasketBall!
    var handballResults: HandBall!
    weak var delegate: MapViewPopupControllerDelegate?
    @IBOutlet weak var milesView: UIView!
    
    @IBOutlet weak var milesPickerView: UIPickerView!
    private let miles = ["1", "2","5","10"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()

    }
    
    private func setupPickerView(){
        milesPickerView.delegate = self
        milesPickerView.dataSource = self
        milesPickerView.layer.cornerRadius = 10
        milesView.layer.cornerRadius = 10
    }
    
    
    //MARK: - Actions
    @IBAction func bringDownView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
   
}
extension MapViewPopupController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return miles.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return miles[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleForMiles = miles[row]
        return NSAttributedString(string: titleForMiles, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.getMilesFromUser(miles: miles[row])
    }
    
}
