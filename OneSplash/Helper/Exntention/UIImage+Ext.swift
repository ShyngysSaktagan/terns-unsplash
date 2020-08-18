//
//  UIImage+Ext.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/18/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

extension UIImage {
    func getCropRatio() -> CGFloat {
        let widthRatio = CGFloat( self.size.width / self.size.height )
        return widthRatio
    }
}
