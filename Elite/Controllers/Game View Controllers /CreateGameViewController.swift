//
//  CreateGameViewController.swift
//  Elite
//
//  Created by Manny Yusuf on 4/9/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController {

    @IBOutlet weak var fiveVsFiveView: UIView!
    @IBOutlet weak var oneVsOneView: UIView!
    @IBOutlet weak var twoVsTwoView: UIView!
    @IBOutlet weak var changeSportView: UIView!
    @IBOutlet weak var selectedSportView: UIView!
    @IBOutlet weak var locationHeader: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewTapGestures()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.155343473, green: 0.1647959352, blue: 0.1777093709, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLayoutSubviews() {
       selectedSportView.layer.borderWidth = 25
        selectedSportView.layer.borderColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
        selectedSportView.layer.cornerRadius = selectedSportView.bounds.width / 2
        selectedSportView.layer.masksToBounds = true
    }
    func setupViewTapGestures(){
        let oneVsOneTap = UITapGestureRecognizer(target: self, action: #selector(oneVsOnePressed))
        oneVsOneView.addGestureRecognizer(oneVsOneTap)
        
        let twoVsTwoTap = UITapGestureRecognizer(target: self, action: #selector(twoVstwoPressed))
        twoVsTwoView.addGestureRecognizer(twoVsTwoTap)
        
        let fiveVsFiveTap = UITapGestureRecognizer(target: self, action: #selector(fiveVsFivePressed))
        fiveVsFiveView.addGestureRecognizer(fiveVsFiveTap)
        
        let changeSportTap = UITapGestureRecognizer(target: self, action: #selector(changeSportPressed))
        changeSportView.addGestureRecognizer(changeSportTap)
        
        let changeParkTap = UITapGestureRecognizer(target: self, action: #selector(changeParkPressed))
        locationHeader.addGestureRecognizer(changeParkTap)
        
        let selectedSportTap = UITapGestureRecognizer(target: self, action: #selector(selectedSportPressed))
        selectedSportView.addGestureRecognizer(selectedSportTap)
        
        
    }
    func animateViews(){

    }
    @objc func oneVsOnePressed() {
        let oneVsOneVc = OneVsOneViewController.init(nibName: "OneVsOneViewController", bundle: nil)
        oneVsOneVc.modalPresentationStyle = .fullScreen
        present(oneVsOneVc, animated: true)
    }
    @objc func twoVstwoPressed() {
        print("2 vs 2")
    }
    @objc func fiveVsFivePressed() {
        print("5 vs 5")
    }
    @objc func changeSportPressed() {
        
    }
    
    @objc func changeParkPressed() {
        let parkListVC = ParkListViewController.init(nibName: "ParkListViewController", bundle: nil)
        parkListVC.modalPresentationStyle = .overCurrentContext
        present(parkListVC, animated: true)
    }
    
    @objc func selectedSportPressed() {
        
    }


}
