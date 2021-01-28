//
//  CharacterDetails.swift
//  MarvelApp
//
//  Created by zeyad on 1/28/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import Foundation

// MARK: - CharacterComics
struct CharacterComics: Codable {
    
    let code: Int?
    let status: String?
    let data: ComicsData?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case status = "status"
        case data = "data"
    }
}

// MARK: - DataClass
struct ComicsData: Codable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [ComicsResult]?

    enum CodingKeys: String, CodingKey {
        case offset = "offset"
        case limit = "limit"
        case total = "total"
        case count = "count"
        case results = "results"
    }
}

// MARK: - Result
struct ComicsResult: Codable {
    let id: Int?
    let title: String?
    let resultDescription: String?
    let thumbnail: Thumbnail?
    let images: [Thumbnail]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case resultDescription = "description"
        case thumbnail = "thumbnail"
        case images = "images"
    }
}
