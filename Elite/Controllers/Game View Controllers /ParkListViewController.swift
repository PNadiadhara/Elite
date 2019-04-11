//
//  ParkListViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/10/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class ParkListViewController: UIViewController {

    @IBOutlet weak var parkListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parkListTableView.dataSource = self
        parkListTableView.delegate = self
        parkListTableView.register(UINib(nibName: "ParkInfoCell", bundle: nil), forCellReuseIdentifier: "ParkInfoCell")
        parkListTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapPressed(){
        dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ParkListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParkInfoCell", for: indexPath) as? ParkInfoCell else {return UITableViewCell()}
        cell.parkNameLabel.text = "Washington Park"
        cell.parkAddressLabel.text = "23-60 Washigton Ave"
        cell.basketballImage.alpha = 0.1
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
}
