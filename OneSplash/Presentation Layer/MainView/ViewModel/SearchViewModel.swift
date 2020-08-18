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
    var photosCurrentPage = 1
    var collectionsCurrentPage = 1
    var usersCurrentPage = 1
    var isPhotosRequestPerforming = false
    var isCollectionRequestPerforming = false
    var isUserRequestPerforming = false
    
    init(service: UnsplashService) {
        self.service = service
    }
    
    func searchUsers(query: String) {
        isUserRequestPerforming = false
        service.searchUsers(query: query, page: usersCurrentPage, success: { [weak self] data in
            self?.isUserRequestPerforming = false
            self?.usersCurrentPage += 1
            self?.users.append(contentsOf: data)
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
    
    func searchPhotos(query: String) {
        isPhotosRequestPerforming = false
        service.searchPhotos(query: query, page: photosCurrentPage, success: { [weak self] data in
            self?.isPhotosRequestPerforming = true
            self?.photosCurrentPage += 1
            self?.photos.append(contentsOf: data)
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
    
    func searchCollections(query: String) {
        isCollectionRequestPerforming = false
        service.searchCollections(query: query, page: collectionsCurrentPage, success: { [weak self] data in
            self?.isCollectionRequestPerforming = true
            self?.collectionsCurrentPage += 1
            self?.collections.append(contentsOf: data)
            self?.didLoadTableItems?()
            }, failure: { error in
                print(error)
        })
    }
}
