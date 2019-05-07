//
//  Constants.swift
//  Elite
//
//  Created by Manny Yusuf on 4/3/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

struct Constants {
    
    static let BioDescriptionPlaceholder = "Tell me about yourself..."
    static let GameBioPlaceholder = "Game Description..."
    static let ProfileImagePath = "profileImages/"
    static let GamePostCellHeight: CGFloat = 150.0
    static func getHelveticaNeue(size: CGFloat, type: String) -> UIFont {
        let fontType = type.capitalized
        switch fontType {
        case "Regular":
            return UIFont(name: "HelveticaNeue", size: size)!
        case "Bold":
            return UIFont(name: "HelveticaNeue-Bold", size: size)!
        case "Light":
            return UIFont(name: "HelveticaNeue-Light", size: size)!
        
        case "Medium":
            return UIFont(name: "HelveticaNeue-Medium", size: size)!
        default:
            return UIFont(name: "HelveticaNeue", size: size)!
        }
    }
}

// https://www.iosapptemplates.com/blog/swift-programming/convert-hex-colors-to-uicolor-swift-4
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red  = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
extension UIColor {
    convenience init? (hexString: String) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet.punctuationCharacters)
        let filteredStr = hexString.filter{"aAbBcCdDeEfF0123456789".contains($0)}
        
        guard hexString.count == filteredStr.count, hexString.count == 6 else {
            return nil
        }
        
        let positionR = hexString.index(hexString.startIndex, offsetBy: 2)
        let positionG = hexString.index(hexString.startIndex, offsetBy: 4)
        
        guard let r = Double("0x" + hexString[..<positionR]),
            let g = Double("0x" + hexString[positionR..<positionG]),
            let b = Double("0x" + hexString[positionG...]) else { return nil }
        
        self.init(red:   CGFloat(r / 255),
                  green: CGFloat(g / 255),
                  blue:  CGFloat(b / 255),
                  alpha: 1)
    }
}
extension UIColor {
    static let tangerine = UIColor(hexString: "fe8c00")!
    static let tomato    = UIColor(hexString: "f83600")!
    static let bluejay   = UIColor(hexString: "00d2ff")!
    static let blueberry = UIColor(hexString: "3a7bd5")!
    static let grass     = UIColor(hexString: "a8e063")!
    static let lime      = UIColor(hexString: "24fe41")!
    static let indigo    = UIColor(hexString: "3f5efb")!
    static let plum      = UIColor(hexString: "5c258d")!
    static let fog       = UIColor(hexString: "ebedee")!
    static let ocean     = UIColor(hexString: "219DFF")!
    static let limerick  = UIColor(hexString: "a2c115")!
    static let spring    = UIColor(hexString: "0fd850")!
    static let kinda     = UIColor(hexString: "50cc7f")!
    static let gold      = UIColor(hexString: "D4AF37")!
    static let lemon     = UIColor(hexString: "f9f047")!
    static let lightGrey = UIColor(hexString: "#434343")!
    static let eliteBlue = UIColor(hexString: "#3A70A7")!
    static let eliteGold = UIColor(hexString: "#BF953F")!
    static let eliteGold2 = UIColor(hexString: "#FCF6BA")! // #00c6ff → #0072ff
    static let fbMessenger = UIColor(hexString: "#00c6ff")!
    static let fbMessenger2 = UIColor(hexString: "#0072ff")!
    static let eliteDarkMode = UIColor(hexString: "#292C2F")!
}
