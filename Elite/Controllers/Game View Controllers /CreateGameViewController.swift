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
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var animatedTopLeft: UIView!
    @IBOutlet weak var animatedTopRight: UIView!
    @IBOutlet weak var animatedBottomLeft: UIView!
    @IBOutlet weak var chooseSportLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewTapGestures()
        currentLocationLabel.text = "Astoria Park"
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
        selectedSportView.layer.borderColor = #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
        selectedSportView.layer.borderWidth = 25
        selectedSportView.layer.cornerRadius = selectedSportView.bounds.width / 2
        selectedSportView.layer.masksToBounds = true
        
        changeSportView.layer.borderWidth = 0
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
        UIView.animate(withDuration: 2.0, delay: 0, options: [], animations: {
            self.animatedTopLeft.transform = CGAffineTransform(translationX: -600, y: 0)
            
        })
        UIView.animate(withDuration: 2.0, delay: 0 , options: [], animations: {
            self.animatedTopRight.transform = CGAffineTransform(translationX: 600, y: 0)
            
        })
        UIView.animate(withDuration: 2.0, delay: 0 , options: [], animations: {
            self.animatedBottomLeft.transform = CGAffineTransform(translationX: 0, y: 600)
            
        })
        UIView.animate(withDuration: 0.5) {
            self.chooseSportLabel.alpha = 0
        }
        
        UIView.animate(withDuration: 2) {
            self.selectedSportView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
    }
    @objc func oneVsOnePressed() {
        let oneVsOneVc = OneVsOneViewController.init(nibName: "OneVsOneViewController", bundle: nil)
        oneVsOneVc.modalPresentationStyle = .fullScreen
        present(oneVsOneVc, animated: true)
    }
    @objc func twoVstwoPressed() {
        let twoVsTwoVc = TwoVsTwoViewController.init(nibName: "TwoVsTwoViewController", bundle: nil)
        twoVsTwoVc.modalPresentationStyle = .fullScreen
        present(twoVsTwoVc, animated: true)
    }
    @objc func fiveVsFivePressed() {
        let fiveVsFiveVc = FiveVsFiveViewController.init(nibName: "FiveVsFiveViewController", bundle: nil)
        fiveVsFiveVc.modalPresentationStyle = .fullScreen
        present(fiveVsFiveVc, animated: true)
    }
    @objc func changeSportPressed() {
       
    }
    
    @objc func changeParkPressed() {
        let parkListVC = ParkListViewController.init(nibName: "ParkListViewController", bundle: nil)
        parkListVC.modalPresentationStyle = .overCurrentContext
        present(parkListVC, animated: true)
    }
    
    @objc func selectedSportPressed() {
         animateViews()
    }


}
