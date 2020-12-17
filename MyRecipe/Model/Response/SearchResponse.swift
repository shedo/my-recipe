//
//  SearchResponse.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 07/12/20.
//

import Foundation

struct SearchResponse: Codable {
    let results: [Recipe]
    let offset, number, totalResults: Int
}
