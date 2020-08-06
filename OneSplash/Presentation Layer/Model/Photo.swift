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
	let width: Int?
	let height: Int?
	let color: String?
	let description: String?
	let altDescription: String?
	let urls: PhotoURLs
    let user: User
}
