//
//  ExploreDetailViewModel.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/6/20.
//  Copyright © 2020 Terns. All rights reserved.
//
//
import UIKit

class PhotoDetailViewModel {
    let service : UnsplashService
    var didLoadTableItems: (() -> Void)?

    var photos: [Photo] = []
    
    init(service: UnsplashService) {
        self.service = service
    }
    
    func getPhotos(id: Int, totalPhotos: Int) {
        service.getPhotos(id: id, totalPhotos: totalPhotos, success: { [weak self]  data in
            self?.photos = data
            self?.didLoadTableItems?()
        }, failure: { error in
            print(error)
        })
    }
}
