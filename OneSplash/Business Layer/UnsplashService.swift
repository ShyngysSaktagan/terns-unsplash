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
    
    // MARK: Get new photos
    func getNewPhotos(page: Int, success: @escaping ([Photo]) -> Void, failure: @escaping (AFError) -> Void) {
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
    
    // MARK: Get photo by id
    func getPhoto(id: String, success: @escaping (Photo) -> Void, failure: @escaping (AFError) -> Void) {
        let params: Parameters = [
            "client_id": UnsplashAPI.Stoken,
            "id": id
        ]
        AF.request(UnsplashAPI.baseURL + UnsplashAPI.photosPostfix + "/\(id)", method: .get, parameters: params).response { (response) in
            switch response.result {
            case .success(let data):
                if data != nil {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let photo = try decoder.decode(Photo.self, from: data!)
                        success(photo)
                    } catch {
                        debugPrint(error)
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // MARK: Get Collections info
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
    
    // MARK: Get Photos by id
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
    
    // MARK: Get Photos by username
    func getUser(username: String, success: @escaping (User) -> Void, failure: @escaping (AFError) -> Void) {
        let params: Parameters = [
            "client_id": UnsplashAPI.Stoken,
            "username": username
        ]
        
        AF.request(UnsplashAPI.baseURL + UnsplashAPI.userPostfix + "/\(username)" , method: .get, parameters: params).response { (response) in
            switch response.result {
            case .success(let data):
                if data != nil {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let user = try decoder.decode(User.self, from: data!)
                        print(user)
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
    
    // MARK: Get profile photos by username
    func getUserPhotos(username: String, page: Int, success: @escaping ([Photo]) -> Void, failure: @escaping (AFError) -> Void) {
        let params: Parameters = [
            "client_id": UnsplashAPI.Stoken,
            "username": username,
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
    
    // MARK: Get profile Likes by username
    func getUserLikes(username: String, page: Int, success: @escaping ([Photo]) -> Void, failure: @escaping (AFError) -> Void) {
        let params: Parameters = [
            "client_id": UnsplashAPI.Stoken,
            "username": username,
            "page": page
        ]
        
        AF.request(UnsplashAPI.baseURL + UnsplashAPI.userPostfix + "/\(username)" +
            UnsplashAPI.likesPostfix , method: .get, parameters: params).response { (response) in
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
    
    // MARK: Get profile Collections by username
    func getUserCollections(username: String, page: Int, success: @escaping ([Collection]) -> Void, failure: @escaping (AFError) -> Void) {
        let params: Parameters = [
            "client_id": UnsplashAPI.Stoken,
            "username": username,
            "page": page
        ]
        AF.request(UnsplashAPI.baseURL + UnsplashAPI.userPostfix + "/\(username)" +
            UnsplashAPI.collectionsPostfix , method: .get, parameters: params).response { (response) in
                switch response.result {
                case .success(let data):
                    if data != nil {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        do {
                            let photos = try decoder.decode([Collection].self, from: data!)
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
    
    // MARK: Search photos by query
    func searchPhotos(query: String, page: Int, success: @escaping ([Photo]) -> Void, failure: @escaping (AFError) -> Void) {
        let params: Parameters = [
            "client_id": UnsplashAPI.Stoken,
            "query": query,
            "page": page
        ]
        
        AF.request(UnsplashAPI.baseURL + UnsplashAPI.searchPostfix + UnsplashAPI.photosPostfix,
                   method: .get, parameters: params).response { (response) in
                    switch response.result {
                    case .success(let data):
                        if data != nil {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            do {
                                let photos = try decoder.decode(PhotoResults.self, from: data!)
                                success(photos.results)
                            } catch {
                                debugPrint(error)
                            }
                        }
                    case .failure(let error):
                        debugPrint(error)
                    }
        }
    }
    
    // MARK: Search collections by query
    func searchCollections(query: String, page: Int, success: @escaping ([Collection]) -> Void, failure: @escaping (AFError) -> Void) {
        let params: Parameters = [
            "client_id": UnsplashAPI.Stoken,
            "query": query,
            "page": page
        ]
        
        AF.request(UnsplashAPI.baseURL + UnsplashAPI.searchPostfix + UnsplashAPI.collectionsPostfix,
                   method: .get, parameters: params).response { (response) in
                    switch response.result {
                    case .success(let data):
                        if data != nil {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            do {
                                let photos = try decoder.decode(CollectionResults.self, from: data!)
                                success(photos.results)
                            } catch {
                                debugPrint(error)
                            }
                        }
                    case .failure(let error):
                        debugPrint(error)
                    }
        }
    }
    
    // MARK: Search user by query
    func searchUsers(query: String, page: Int, success: @escaping ([User]) -> Void, failure: @escaping (AFError) -> Void) {
        let params: Parameters = [
            "client_id": UnsplashAPI.Stoken,
            "query": query,
            "page": page
        ]
        
        AF.request(UnsplashAPI.baseURL + UnsplashAPI.searchPostfix + UnsplashAPI.userPostfix,
                   method: .get, parameters: params).response { (response) in
                    switch response.result {
                    case .success(let data):
                        if data != nil {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            do {
                                let photos = try decoder.decode(UserResults.self, from: data!)
                                success(photos.results)
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
