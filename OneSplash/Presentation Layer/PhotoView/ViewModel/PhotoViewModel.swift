//
//  PhotoViewModel.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/13/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class PhotoViewModel {
    let service : UnsplashService
    var didLoadTableItems: (() -> Void)?
    var photo: Photo?
    var currentPhoto: UIImageView?
    
    init(service: UnsplashService) {
        self.service = service
    }
    
    func getPhoto(id: String) {
        service.getPhoto(id: id, success: { [weak self]  data in
            self?.photo = data
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
}
