//
//  Results.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/16/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import Foundation

struct PhotoResults: Codable {
    let results: [Photo]
}

struct CollectionResults: Codable {
    let results: [Collection]
}

struct UserResults: Codable {
    let results: [User]
}
