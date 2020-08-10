//
//  UnsplashService.swift
//  OneSplash
//
//  Created by Rustam-Deniz on 8/4/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import Foundation
import Alamofire

class UnsplashService {
	
    func getSamplePhotos(page: Int, success: @escaping ([Photo]) -> Void, failure: @escaping (AFError) -> Void) {
		let params: Parameters = [
			"client_id": UnsplashAPI.Stoken,
            "page" : page
		]
		AF.request(UnsplashAPI.baseURL + UnsplashAPI.photosPostfix, method: .get, parameters: params).response { (response) in
			switch response.result {
			case .success(let data):
				if data != nil {
					let decoder = JSONDecoder()
					decoder.keyDecodingStrategy = .convertFromSnakeCase
					do {
						let photos = try decoder.decode([Photo].self, from: data!)
						success(photos)                        
					} catch {
						debugPrint(error)
					}
				}
			case .failure(let error):
				debugPrint(error)
			}
		}
	}
    
    func getCollections(page: Int, success: @escaping ([Collection]) -> Void, failure: @escaping (AFError) -> Void) {
        let params: Parameters = [
            "client_id": UnsplashAPI.Stoken,
            "page": page
        ]
        
        AF.request(UnsplashAPI.baseURL + UnsplashAPI.collectionsPostfix, method: .get, parameters: params).response { (response) in
            switch response.result {
            case .success(let data):
                if data != nil {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let collection = try decoder.decode([Collection].self, from: data!)
//                        print(collection)
                        success(collection)
                    } catch {
                        debugPrint(error)
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func getPhotos(id: Int, totalPhotos: Int, success: @escaping ([Photo]) -> Void, failure: @escaping (AFError) -> Void) {
        let params: Parameters = [
            "client_id": UnsplashAPI.Stoken,
            "id": id,
            "per_page": totalPhotos
        ]
        
        AF.request(UnsplashAPI.baseURL + UnsplashAPI.collectionsPostfix + "/\(id)/\(UnsplashAPI.photosPostfix)"
            , method: .get, parameters: params).response { (response) in
            switch response.result {
            case .success(let data):
                if data != nil {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let photos = try decoder.decode([Photo].self, from: data!)
//                        print(photos)
                        success(photos)
                    } catch {
                        debugPrint(error)
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func getUser(username: String, success: @escaping (User) -> Void, failure: @escaping (AFError) -> Void) {
        let params: Parameters = [
            "client_id": UnsplashAPI.Stoken
        ]
        
        AF.request(UnsplashAPI.baseURL + UnsplashAPI.userPostfix + "/\(username)" , method: .get, parameters: params).response { (response) in
            switch response.result {
            case .success(let data):
                if data != nil {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let user = try decoder.decode(User.self, from: data!)
//                        print(photos)
                        success(user)
                    } catch {
                        debugPrint(error)
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func getUserPhotos(username: String, page: Int, success: @escaping ([Photo]) -> Void, failure: @escaping (AFError) -> Void) {
        let params: Parameters = [
            "client_id": UnsplashAPI.Stoken,
            "page": page
        ]
        
        AF.request(UnsplashAPI.baseURL + UnsplashAPI.userPostfix + "/\(username)" +
            UnsplashAPI.photosPostfix , method: .get, parameters: params).response { (response) in
            switch response.result {
            case .success(let data):
                if data != nil {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let photos = try decoder.decode([Photo].self, from: data!)
                        success(photos)
                    } catch {
                        debugPrint(error)
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
