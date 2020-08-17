//
//  SearchViewModel.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/16/20.
//  Copyright © 2020 Terns. All rights reserved.
//

class SearchViewModel {
    
    let service : UnsplashService
    var didLoadTableItems: (() -> Void)?
    var photos: [Photo]             = []
    var users: [User]               = []
    var collections: [Collection]   = []
    var searchText: String?
    
    init(service: UnsplashService) {
        self.service = service
    }
    
    func searchUsers(query: String) {
        service.searchUsers(query: query, success: { [weak self] data in
            self?.users.append(contentsOf: data)
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
    
    func searchPhotos(query: String) {
        service.searchPhotos(query: query, success: { [weak self] data in
            self?.photos.append(contentsOf: data)
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
    
    func searchCollections(query: String) {
        service.searchCollections(query: query, success: { [weak self] data in
            self?.collections.append(contentsOf: data)
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
}
