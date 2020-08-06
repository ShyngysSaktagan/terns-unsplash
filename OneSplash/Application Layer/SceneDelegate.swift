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
        let viewModel = MainViewViewModel(service: service)
		let mainVC = MainScreenViewController(viewModel: viewModel)
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
        UINavigationBar.appearance().isTranslucent = true
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

