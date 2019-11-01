//
//  UIView+Extensions.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/25/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation
import UIKit
extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}
extension UIView {
    func setGradientFromUpperLeftToBottmRight(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.cornerRadius = 5
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setGradientFromBottmRightToUpperLeft(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.cornerRadius = 5
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setGradientFromBottomLeftToUpperRight(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        layer.cornerRadius = 5
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setGradientFromUpperRightToBottomLeft(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        layer.cornerRadius = 5
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setGradientFromRightToLeft(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.cornerRadius = 5
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setGradientFromLeftToRight(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        layer.cornerRadius = 5
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setGradientFromTopToBottm(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        layer.cornerRadius = 5
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setGradientFromBottmToTop(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.cornerRadius = 5
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setMultiColorGradient(_ coreGraphicColors: [CGColor] ){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = coreGraphicColors
        //        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.cornerRadius = 5
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
/*
 1. let gradientLayer = CAGradientLayer() means creating the instance
 
 2. gradientLayer.frame = bounds means setting the frame to the bounds of whatever object you want it to be ex: Button or View "Taking up the entire space"
 
 3. gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor] means its taking in an array of colors cg = core graphics which is needed for this layer
 
 4. gradientLayer.locations = [0.0, 1.0] (OPTIONAL) means the breakpoint in the gradient where the two colors mix. By default the colors mix in the middle
 - [0.0, 1.0] means it is going to blend in the middle
 
 5. gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0) means where the gradient starts
 - (x: 1.0, y: 1.0) means its starting at the upper left hand corner
 
 6. gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0) means where the gradient ends
 - (x: 0.0, y: 0.0) means its ending at the lower right hand corner
 
 7. layer.insertSublayer(gradientLayer, at: 0) means inserting the gradient in the sublayer @ 0 "The First layer"
 */
