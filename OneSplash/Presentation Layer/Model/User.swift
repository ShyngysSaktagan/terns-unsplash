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
    let name: String?
    let username: String
    let instagramUsername: String?
    let location: String?
    let totalCollections: Int?
    let totalLikes: Int?
    let portfolioUrl: String?
    let links: Links?
    let totalPhotos: Int?
    let profileImage: ProfileImage?
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

struct Links: Codable {
    let html: String
}
