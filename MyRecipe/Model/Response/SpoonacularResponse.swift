//
//  SpoonacularResponse.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 07/12/20.
//

import Foundation

struct SpoonacularResponse: Codable {
    let status: String
    let code: Int
    let message: String
}

extension SpoonacularResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
