//
//  UIImageView+Ext.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/18/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import Alamofire

var imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    convenience init(cornerRadius: CGFloat) {
        self.init(image: nil)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds      = true
        self.contentMode        = .scaleAspectFill
    }
    
    func load(urlString: String) {
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            return
        }
        
        AF.request(urlString, method: .get).response { (response) in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
