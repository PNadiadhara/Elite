//
//  LoadingViewController.swift
//  Elite
//
//  Created by Leandro Wauters on 11/7/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var gamerID: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentGamer(gamerID: gamerID)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, gamerID: String) {
        self.gamerID = gamerID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchCurrentGamer(gamerID: String) {
        DBService.fetchGamer(gamerID: gamerID) { (error, gamer) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let gamer = gamer {
                GamerModel.currentGamer = gamer
                let tab = TabBarViewController()
                let nav = UINavigationController(rootViewController: tab)
                nav.modalPresentationStyle = .fullScreen
                tab.navigationController?.isNavigationBarHidden = true
                self.present(nav, animated: true)
            }
        }
    }


}
