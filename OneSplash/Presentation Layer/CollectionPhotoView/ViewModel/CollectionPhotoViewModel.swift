//
//  ExploreDetailViewModel.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/6/20.
//  Copyright © 2020 Terns. All rights reserved.
//
//
import UIKit

class CollectionPhotoViewModel {
    let service : UnsplashService
    var didLoadTableItems: (() -> Void)?
    var page                = 1
    let constantCount       = 8
    var counting            = 8
    var photos: [Photo]     = []
    var isRequestPerforming = false
    
    init(service: UnsplashService) {
        self.service = service
    }
    
    func getCollectionPhotos(id: Int, totalPhotos: Int) {
        service.getPhotos(id: id, totalPhotos: totalPhotos, success: { [weak self]  data in
            containerView.alpha = 0
            containerView       = nil
            self?.photos        = data
            self?.didLoadTableItems?()
        }, failure: { error in
            containerView.alpha = 0
            containerView       = nil
            print(error)
        })
    }
    
    func getNewPhotos() {
        isRequestPerforming = true
        service.getNewPhotos(page: page, success: { [weak self]  data in
            self?.isRequestPerforming = false
            containerView.alpha = 0
            containerView       = nil
            self?.photos.append(contentsOf: data)
            self?.didLoadTableItems?()
            }, failure: { error in
                containerView.alpha = 0
                containerView       = nil
                print(error)
        })
    }
}
