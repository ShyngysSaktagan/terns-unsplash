//
//  ProfileViewModel.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/15/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class ProfileViewModel {
    let service : UnsplashService
    var photos: [Photo]             = []
    var likes: [Photo]              = []
    var collections: [Collection]   = []
    var user: User?
    var username: String
    var didLoadTableItems: (() -> Void)?
    var photosCurrentPage = 1
    var collectionsCurrentPage = 1
    var likesCurrentPage = 1
    var isPhotosRequestPerforming = false
    var isCollectionRequestPerforming = false
    var isLikesRequestPerforming = false
    
    init(service: UnsplashService, username: String) {
        self.service    = service
        self.username   = username.lowercased()
    }
    
    func getUserPhotos() {
        isPhotosRequestPerforming = true
        service.getUserPhotos(username: username, page: photosCurrentPage, success: { [weak self] data in
            self?.isPhotosRequestPerforming = false
            self?.photosCurrentPage += 1
            self?.photos.append(contentsOf: data)
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
    
    func getUserLikes() {
        isLikesRequestPerforming = true
        service.getUserLikes(username: username, page: likesCurrentPage, success: { [weak self] data in
            self?.isLikesRequestPerforming = false
            self?.likesCurrentPage += 1
            self?.likes.append(contentsOf: data)
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
    
    func getUserCollections() {
        isCollectionRequestPerforming = true
        service.getUserCollections(username: username, page: collectionsCurrentPage, success: { [weak self] data in
            self?.isCollectionRequestPerforming = false
            self?.collectionsCurrentPage += 1
            self?.collections.append(contentsOf: data)
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
    
    func getUser() {
        service.getUser(username: username, success: { [weak self] data in
            self?.user = data
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
}
