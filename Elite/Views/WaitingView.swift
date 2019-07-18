//
//  WaitingView.swift
//  Elite
//
//  Created by Leandro Wauters on 6/26/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
protocol WaitingViewDelegate: AnyObject {
    func cancelPressed()
}
class WaitingView: UIView {
    static weak var watingViewDelegate: WaitingViewDelegate?
    
    @IBOutlet weak var waitingSubView: UIView!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        WaitingView.watingViewDelegate?.cancelPressed()
    }
    
    class func instanceFromNib() -> WaitingView {
        return UINib(nibName: "WaitingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView as! WaitingView
        
    }
    class func setViewContraints(titleText: String?, isHidden: Bool, delegate: UIViewController,view: UIView, callBack: @escaping(WaitingView) -> Void) {
        let waitingViewpro = WaitingView.instanceFromNib()
        watingViewDelegate = delegate as? WaitingViewDelegate
        view.addSubview(waitingViewpro)
        waitingViewpro.frame.size = view.frame.size
        waitingViewpro.viewTitle.text = titleText
        waitingViewpro.isHidden = isHidden
        callBack(waitingViewpro)
//        waitingViewpro.translatesAutoresizingMaskIntoConstraints = false
//        waitingViewpro.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        waitingViewpro.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        waitingViewpro.heightAnchor.constraint(equalToConstant: 269).isActive = true
//        waitingViewpro.widthAnchor.constraint(equalToConstant: 217).isActive = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
