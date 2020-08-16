//
//  SceneDelegate.swift
//  OneSplash
//
//  Created by Terns on 8/4/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }
        configureNavigationBar()
		let window = UIWindow(windowScene: scene)
        let service = UnsplashService()
        let mainViewViewModel = MainViewViewModel(service: service)
        let photoViewModel = PhotoDetailViewModel(service: service)
        let searchViewModel = SearchViewModel(service: service)
        let mainVC = MainScreenViewController(mainViewViewModel: mainViewViewModel, photoViewModel: photoViewModel, searchViewModel: searchViewModel)
		let nav = UINavigationController(rootViewController: mainVC)
		window.rootViewController = nav
		self.window = window
		window.backgroundColor = .white
		window.makeKeyAndVisible()
	}
    
    func configureNavigationBar() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UIBarButtonItem.appearance().tintColor = .white
//        UIBarButtonItem.appearance().cl
        UINavigationBar.appearance().isTranslucent = true
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)

    }
    
	func sceneDidDisconnect(_ scene: UIScene) {
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
	}

	func sceneWillResignActive(_ scene: UIScene) {
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
	}


}

