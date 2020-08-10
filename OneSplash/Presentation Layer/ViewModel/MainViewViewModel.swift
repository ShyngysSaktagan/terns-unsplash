//
//  MainViewViewModel.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/5/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class MainViewViewModel {
    
    var collections : [Collection] = []
    var page = 1
    var counting = 8
    let constantCount = 8
    
    let service : UnsplashService
    var didLoadTableItems: (() -> Void)?
    
    init(service: UnsplashService) {
        self.service = service
    }
    
    func getCollections(page: Int) {
        service.getCollections(page: page, success: { [weak self]  data in
            self?.collections.append(contentsOf: data)
            self?.didLoadTableItems?()
        }, failure: { error in
            print(error)
        })
    }
}
