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
    var appCoordinator: AppCoordinator!

    // MARK: Window
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        configureNavigationBar()
        window = UIWindow(windowScene: windowScene)
        
        appCoordinator = AppCoordinator(navigationController: UINavigationController())
        appCoordinator.start()
        
        window?.rootViewController = appCoordinator.navigationController
        window?.makeKeyAndVisible()
	}
    
    func configureNavigationBar() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage                = UIImage()
        UIBarButtonItem.appearance().tintColor                  = .white
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
