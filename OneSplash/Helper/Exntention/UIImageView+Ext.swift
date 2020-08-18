//
//  UIImageView+Ext.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/18/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

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
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
}
