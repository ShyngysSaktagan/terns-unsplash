//
//  AppCordinator.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/16/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let mainViewViewModel: MainScreenViewModel
    let photoViewModel: CollectionPhotoViewModel
    let searchViewModel: SearchViewModel
    var navigationController: UINavigationController
    
    var changeContact: ((Int) -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        mainViewViewModel   = MainScreenViewModel(service: UnsplashService())
        photoViewModel      = CollectionPhotoViewModel(service: UnsplashService())
        searchViewModel     = SearchViewModel(service: UnsplashService())
    }
    
    override func start() {
        showMainPage(mainViewViewModel: mainViewViewModel, photoViewModel: photoViewModel, searchViewModel: searchViewModel)
    }
    
    // MARK: Main Page
    private func showMainPage(mainViewViewModel: MainScreenViewModel, photoViewModel: CollectionPhotoViewModel, searchViewModel: SearchViewModel) {
        let page = MainScreenViewController(mainViewViewModel: mainViewViewModel, photoViewModel: photoViewModel, searchViewModel: searchViewModel,
            didSelectUser: { [weak self] username in
                self?.showProfilePage(username: username, viewModel: ProfileViewModel(service: UnsplashService(), username: username))
            }, didSelectPhoto: { [weak self] photos, index in
                self?.showPhotoPage(viewModel: PhotoViewModel(service: UnsplashService()), index: index, photos: photos)
            }, didSelectCollection: { [weak self] collections, index in
                self?.showCollectionPage(viewModel: CollectionPhotoViewModel(service: UnsplashService()), index: index, collections: collections)
            }
        )
        
        let service = UnsplashService()
        
        self.changeContact = { [weak page] index in
            page?.indexPathToStart = index
        }
        
        page.didSelectUser = { [weak self] (username) in
            self?.showProfilePage(username: username, viewModel: ProfileViewModel(service: UnsplashService(), username: username))
        }
        
        page.didSelectPhoto = { [weak self] photos, index in
            self?.showPhotoPage(viewModel: PhotoViewModel(service: service), index: index, photos: photos)
        }
        
        page.didSelectCollection = { [weak self] collections, index in
            self?.showCollectionPage(viewModel: CollectionPhotoViewModel(service: service), index: index, collections: collections)
        }
    
        navigationController.pushViewController(page, animated: true)
    }
    
    // MARK: Profile Page
    func showProfilePage(username: String, viewModel: ProfileViewModel) {
        let page = ProfileViewController(viewModel: viewModel)
        
        self.changeContact = { [weak page] index in
            page?.indexPathToStart = index
        }
        
        page.didSelectUser = { [weak self] (username) in
            self?.showProfilePage(username: username, viewModel: ProfileViewModel(service: UnsplashService(), username: username))
        }
        
        page.didSelectLike = { [weak self] photos, index in
            self?.showPhotoPage(viewModel: PhotoViewModel(service: UnsplashService()), index: index, photos: photos)
        }
        
        page.didSelectPhoto = { [weak self] photos, index in
            self?.showPhotoPage(viewModel: PhotoViewModel(service: UnsplashService()), index: index, photos: photos)
        }
        
        page.didSelectCollection = { [weak self] collections, index in
            self?.showCollectionPage(viewModel: CollectionPhotoViewModel(service: UnsplashService()), index: index, collections: collections)
        }
        
        navigationController.pushViewController(page, animated: true)
    }
    
    // MARK: Photo Page
    func showPhotoPage(viewModel: PhotoViewModel, index: Int, photos: [Photo]) {
        let item = photos[index]
        let page = PhotoViewController(viewModel: viewModel)
        
        page.didExitClicked = { [weak self] (index) in
            self?.changeContact?(index)
            self?.navigationController.popViewController(animated: true)
        }
        
        page.didSelectUser = { [weak self] (username) in
            self?.showProfilePage(username: username, viewModel: ProfileViewModel(service: UnsplashService(), username: username))
        }
        
        page.photos = photos
        page.indexPathToScroll = index
        page.titleButton.setTitle(item.user.username, for: .normal)
        navigationController.pushViewController(page, animated: true)
    }
    
    // MARK: Photo Collections Page
    func showCollectionPage(viewModel: CollectionPhotoViewModel, index: Int, collections: [Collection]) {
        let item = collections[index]
        let page = CollectionPhotoViewController(viewModel: viewModel)
        
        self.changeContact = { [weak page] index in
            page?.indexPathToStart = index
        }
        
        page.didSelectPhoto = { [weak self] photos, index in
            self?.showPhotoPage(viewModel: PhotoViewModel(service: UnsplashService()), index: index, photos: photos)
        }
        
        page.didSelectUser = { [weak self] (username) in
            self?.showProfilePage(username: username, viewModel: ProfileViewModel(service: UnsplashService(), username: username))
        }
        
        page.collection = item
        page.title = item.title
        navigationController.pushViewController(page, animated: true)
    }
}
