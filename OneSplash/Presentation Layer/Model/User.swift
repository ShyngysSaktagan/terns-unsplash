//
//  CollectionPhoto.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/6/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let username: String
//    let firstName: String
//    let lastName: String
//    let portfolioUrl: String
//    let location: String
//    let totalCollections: Int
//    let totalLikes: Int
//    let totalPhotos: Int
    let profileImage: ProfileImage
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}
