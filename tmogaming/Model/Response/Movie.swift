//
//  Movie.swift
//  tmogaming
//
//  Created by Shishir Ahmed on 1/7/20.
//  Copyright © 2020 Shishir Ahmed. All rights reserved.
//

import Foundation

// MARK: - Movie
struct Movie: Codable {
    var d: [D]
    var q: String?
    var v: Int?
}

// MARK: - D
struct D: Codable {
    var i: I?
    var id, l, s: String?
    var rank: Int?
    var v: [V]?
    var vt: Int?
    var q: String?
    var y: Int?
}

// MARK: - I
struct I: Codable {
    var imageURL: String?
    var height, width: Int?

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case height, width
    }
}

// MARK: - V
struct V: Codable {
    var i: I?
    var id, l, s: String?
}
