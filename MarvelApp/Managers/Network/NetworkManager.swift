//
//  NetworkManager.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import Foundation
import Keys

//MARK:- this configuration requried to make successfull call to marvel api's

fileprivate struct MarvelAPIConfig {
    fileprivate static let keys = MarvelKeys()
    static let privatekey = keys.marvelPrivateKey
    static let apikey = keys.marvelApiKey
    static let ts = Date().timeIntervalSince1970.debugDescription
    static let hash = "\(ts)\(privatekey)\(apikey)".md5()
}

//MARK:- Network Manager
/*
 I used a native solution to build network request instead of using Alamofire , moya or any other alternatives
 to prove understaning of the core concepts , in producton i use a protocol orianted network layer usnig any of them
 
 */
class NetworkManager {
    
    static let shared = NetworkManager()
    let cache = NSCache<NSString,UIImage>()
    
    
    #warning("Incase of the key is expired or somthing you can switch the quaryParameters to the Static one")
    //    var quaryParameters:[String: Any]  = ["apikey": "001ac6c73378bbfff488a36141458af2",
    //                                          "ts": "thesoer",
    //                                          "hash": "72e5ed53d1398abb831c3ceec263f18b"]
    
    
    let quaryParameters:[String: Any]  = ["apikey": MarvelAPIConfig.apikey,
                                          "ts": MarvelAPIConfig.ts,
                                          "hash": MarvelAPIConfig.hash]
    
    var baseURL: URL? {
        return URL(string: "https://gateway.marvel.com/v1/public/")
    }
    
    func getCharchtersList(searchText:String? , offset:Int , completion: @escaping (Result<MarvelCharacters,MError>) -> Void ) {
        
        let endPonit = baseURL?.appendingPathComponent("characters")
        guard let url = endPonit else {
            completion(.failure(.invalidURL))
            return
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = quaryParameters.map{
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        urlComponents?.queryItems = queryItems
        if let text = searchText {
            urlComponents?.queryItems?.append(URLQueryItem(name: "nameStartsWith", value: text))
        }
        urlComponents?.queryItems?.append(URLQueryItem(name: "offset", value: "\(offset)"))
        guard let fullUrl = urlComponents?.url else {return}
        let task = URLSession.shared.dataTask(with: fullUrl) { (data, response, error) in
            if let _ = error {
                completion(.failure(.connectionError))
                return
            }
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidDate))
                return
            }
            do {
                let decoder = JSONDecoder()
                let productListModel = try decoder.decode(MarvelCharacters.self, from: data)
                completion(.success(productListModel))
            }
            catch{
                completion(.failure(.decodeError))
            }
        }
        task.resume()
    }
    
    func getCharchterComics(id:Int, completion: @escaping (Result<CharacterComics,MError>) -> Void ) {
        
        let endPonit = baseURL?.appendingPathComponent("characters/\(id)/comics")
        guard let url = endPonit else {
            completion(.failure(.invalidURL))
            return
        }
        
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = quaryParameters.map{
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        urlComponents?.queryItems = queryItems
        
        guard let fullUrl = urlComponents?.url else {return}
        let task = URLSession.shared.dataTask(with: fullUrl) { (data, response, error) in
            if let _ = error {
                completion(.failure(.connectionError))
                return
            }
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidDate))
                return
            }
            do {
                let decoder = JSONDecoder()
                let productListModel = try decoder.decode(CharacterComics.self, from: data)
                completion(.success(productListModel))
            }
            catch{
                completion(.failure(.decodeError))
            }
        }
        task.resume()
    }
    
    //MARK:- Download images(only one time) then Caching it
    
    /*
     this is instead of using KingFisher pod , sdWebImage or any other alternatives
     */
    
    func downloadImage(from stringURL:String , completed: @escaping (UIImage?) -> Void) {
        let imageKey = NSString(string: stringURL)
        
        if let image = cache.object(forKey: imageKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: stringURL) else {
            completed(nil)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self ,
                error == nil ,
                let response = response as? HTTPURLResponse ,
                response.statusCode == 200 ,
                let data = data ,
                let image = UIImage(data: data)
                else {
                    
                    completed(Images.placeholder)
                    return
            }
            self.cache.setObject(image, forKey: imageKey)
            completed(image)
        }
        
        dataTask.resume()
    }
    
}


