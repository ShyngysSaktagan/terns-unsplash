//
//  UIColor+Ext.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/18/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

extension UIColor {
    static let bcc = UIColor(red: 17 / 255, green: 17 / 255, blue: 17 / 255, alpha: 1)
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask    = 0x000000FF
        let rred    = Int(color >> 16) & mask
        let ggreen  = Int(color >> 8) & mask
        let bblue   = Int(color) & mask
        let red     = CGFloat(rred) / 255.0
        let green   = CGFloat(ggreen) / 255.0
        let blue    = CGFloat(bblue) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
