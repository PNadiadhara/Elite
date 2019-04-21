//
//  AVCapturePreviewView.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/21/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit
import AVFoundation

class AVCapturePreviewView: UIView {

    override class var layerClass: Swift.AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var avPreviewLayer: AVCaptureVideoPreviewLayer { return layer as! AVCaptureVideoPreviewLayer }

}
