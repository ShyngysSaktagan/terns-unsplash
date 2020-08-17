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
    
    init(service: UnsplashService, username: String) {
        self.service    = service
        self.username   = username.lowercased()
    }
    
    func getUserPhotos() {
        service.getUserPhotos(username: username, success: { [weak self] data in
            self?.photos.append(contentsOf: data)
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
    
    func getUserLikes() {
        service.getUserLikes(username: username, success: { [weak self] data in
            self?.likes.append(contentsOf: data)
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
    
    func getUserCollections() {
        service.getUserCollections(username: username, success: { [weak self] data in
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
