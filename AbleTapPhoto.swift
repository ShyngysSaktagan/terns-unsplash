//
//  AbleTapPhoto.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/9/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

protocol AbleTapPhoto: UIViewController {

    let zoomImageView = UIImageView()
    let blackBackgroud = UIView()
    var photoView: UIImageView?
    let navBarCover = UIView()
    
    func animate(photoView: UIImageView) {
        self.photoView = photoView
        if let startingFrame = photoView.superview?.convert(photoView.frame, to: nil) {
            
            photoView.alpha = 0
            blackBackgroud.backgroundColor = .bcc
            blackBackgroud.frame = view.frame
            blackBackgroud.alpha = 0
            view.addSubview(blackBackgroud)
            
            navBarCover.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
            navBarCover.backgroundColor = .bcc
            navBarCover.alpha = 0
            view.addSubview(navBarCover)
            
            zoomImageView.frame = CGRect(x: 0, y: startingFrame.origin.y - 87.7, width: self.view.frame.width, height:startingFrame.height)
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = photoView.image
            zoomImageView.contentMode = .scaleAspectFill
    //           zoomImageView.alpha = 0.4
            zoomImageView.clipsToBounds = true
            zoomImageView.backgroundColor = .red
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.75) {
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                let y = self.view.frame.height / 2 - height / 2
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                self.navBarCover.alpha = 1
                self.blackBackgroud.alpha = 1
            }
        }
    }
    
    func zoomOut() {
        if let startingFrame = photoView!.superview?.convert(photoView!.frame, to: nil) {
            UIView.animate(withDuration: 0.75, animations: {
                self.zoomImageView.frame = CGRect(x: 0, y: startingFrame.origin.y - 87.7, width: self.view.frame.width,height: startingFrame.height)
                self.blackBackgroud.alpha = 0
                self.navBarCover.alpha = 0
            }) { (didComplete) in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroud.removeFromSuperview()
                self.navBarCover.removeFromSuperview()
                self.photoView?.alpha = 1
            }
        }
    }

}
