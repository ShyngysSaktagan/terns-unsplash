//
//  Photo.swift
//  OneSplash
//
//  Created by Rustam-Deniz on 8/4/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import Foundation

struct Photo: Codable, Identifiable {
	let id: String
	let createdAt: String
	let updatedAt: String
	let width: Int
	let height: Int
	let color: String?
	let description: String?
    let exif: Exif?
	let altDescript: String?
    let location: Location?
	let urls: PhotoURLs
    let user: User
}

struct Exif: Codable {
    let make: String?
    let model: String?
    let exposureTime: String?
    let aperture: String?
    let focalLength: String?
    let iso: Int?
}

struct Location: Codable {
    
}
