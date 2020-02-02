//
//  DataModel.swift
//  LBStore
//
//  Created by wira on 2/2/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

import Foundation

// MARK: - ArticleElement
struct ArticleElement: Decodable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    let category: [Category]
    let productPromo: [ProductPromo]
}

// MARK: - Category
struct Category: Decodable {
    let imageURL: String
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case id, name
    }
}

// MARK: - ProductPromo
struct ProductPromo: Decodable {
    let id: String
    let imageURL: String
    let title, productPromoDescription, price: String
    let loved: Int

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "imageUrl"
        case title
        case productPromoDescription = "description"
        case price, loved
    }
}

typealias Article = [ArticleElement]
