//
//  SnapchatView.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 5/5/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class SnapchatView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    
    @IBOutlet weak var loginBttn: UIButton!
    
    @IBOutlet weak var cancelBttn: UIButton!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        setupView()
    }
    
    private func setupView() {
        // load the nib file
        Bundle.main.loadNibNamed("SnapchatView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
   
}
