//
//  Coordinator.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/16/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import Foundation

class Coordinator {
    var childCoordinators: [Coordinator] = []
    
    func start() { }
    
    func add(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator) {
        //
    }
}
