//
//  AppCordinator.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/16/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        ShowMainPage()
    }
    
    private func ShowMainPage(){
        let page = MainScreenViewController { [weak self] user in
            self?.showUserProfile(user: user, viewModel: MainViewViewModel(service: UnsplashService()))
        }
        navigationController.pushViewController(page, animated: true)
    }
    
    func showUserProfile(user: User, viewModel: ProfileViewModel){
        let page = ProfileViewController(user: user, viewModel: viewModel)
        navigationController.pushViewController(page, animated: true)
    }
}
