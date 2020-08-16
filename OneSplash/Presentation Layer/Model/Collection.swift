//
//  Collection.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/5/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import Foundation

struct Collection: Codable, Identifiable {
    let id: Int
    let title: String
    let coverPhoto: Photo
    let totalPhotos : Int
    let links: Links?
}
