//
//  Models.swift
//  KaryshkyrApp
//
//  Created by User on 10/21/22.
//

import Foundation

struct WordsResponse: Codable {
    var count: Int
    var next: String
    var results: [WordModel]
}

struct WordModel: Codable {
    var title: String
    var description: String
    var is_verified: Bool
    var is_new: Bool
}
