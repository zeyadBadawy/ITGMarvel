//
//  MarvelCharcters.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import Foundation

// MARK: - MarvelCharacters
struct MarvelCharacters: Codable {
    let code: Int?
    let status: String?
    let data: DataClass?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case status = "status"
        case data = "data"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [MCharcter]?

    enum CodingKeys: String, CodingKey {
        case offset = "offset"
        case limit = "limit"
        case total = "total"
        case count = "count"
        case results = "results"
    }
}

// MARK: - Result
struct MCharcter: Codable {
    let id: Int?
    let name: String?
    let resultDescription: String?
    let thumbnail: Thumbnail?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case resultDescription = "description"
        case thumbnail = "thumbnail"
    }
}


// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String?
    let thumbnailExtension: Extension?

    enum CodingKeys: String, CodingKey {
        case path = "path"
        case thumbnailExtension = "extension"
    }
}

enum Extension: String, Codable {
    case gif = "gif"
    case jpg = "jpg"
}

