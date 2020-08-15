//
//  Extensions.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/5/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.numberOfLines = numberOfLines
    }
}

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
        let mask = 0x000000FF
        let rred = Int(color >> 16) & mask
        let ggreen = Int(color >> 8) & mask
        let bblue = Int(color) & mask
        let red   = CGFloat(rred) / 255.0
        let green = CGFloat(ggreen) / 255.0
        let blue  = CGFloat(bblue) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

var imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    convenience init(cornerRadius: CGFloat) {
        self.init(image: nil)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
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

extension UIImage {
    func getCropRatio() -> CGFloat {
        let widthRatio = CGFloat( self.size.width / self.size.height )
        return widthRatio
    }
}

extension UIButton {
    convenience init(title: String) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
    }
}

extension UIViewController {

func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
    if #available(iOS 13.0, *) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes                   = [.foregroundColor: largeTitleColor]
        navBarAppearance.titleTextAttributes                        = [.foregroundColor: largeTitleColor]
        navBarAppearance.backgroundColor                            = backgoundColor

        navigationController?.navigationBar.standardAppearance      = navBarAppearance
        navigationController?.navigationBar.compactAppearance       = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance    = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles      = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent           = false
        navigationController?.navigationBar.tintColor               = tintColor
        navigationItem.title                                        = title

    } else {
        navigationController?.navigationBar.barTintColor            = backgoundColor
        navigationController?.navigationBar.tintColor               = tintColor
        navigationController?.navigationBar.isTranslucent           = false
        navigationItem.title                                        = title
    }
    }
}

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    func convertToDate() -> Date? {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone      = .current
        
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
}
