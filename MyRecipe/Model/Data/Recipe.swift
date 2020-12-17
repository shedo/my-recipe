//
//  RecipeResponse.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 07/12/20.
//

import Foundation

struct Recipe: Codable {
    let id: Int?
    let title: String
    let image: String?
    let imageType: String?
}
