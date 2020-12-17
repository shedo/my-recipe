//
//  RecipeDetailResponse.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 07/12/20.
//

import Foundation

struct RecipeDetailResponse: Codable {
    let vegetarian, vegan, glutenFree, dairyFree: Bool
    let veryHealthy, cheap, veryPopular, sustainable: Bool
    let weightWatcherSmartPoints: Int
    let gaps: String
    let lowFodmap: Bool
    let aggregateLikes, spoonacularScore, healthScore: Int
    let creditsText, license, sourceName: String
    let pricePerServing: Double
    let extendedIngredients: [ExtendedIngredient]?
    let id: Int
    let title: String
    let readyInMinutes, servings: Int
    let sourceUrl: String
    let image: String?
    let imageType, summary: String?
    let cuisines, dishTypes: [String]
    let instructions: String
    let analyzedInstructions: [AnalyzedInstruction]?
    let spoonacularSourceUrl: String
}

// MARK: - AnalyzedInstruction
struct AnalyzedInstruction: Codable {
    let name: String
    let steps: [Step]
}

// MARK: - Step
struct Step: Codable {
    let number: Int
    let step: String
    let ingredients, equipment: [Ent]
    let length: Length?
}

// MARK: - Ent
struct Ent: Codable {
    let id: Int
    let name, localizedName, image: String
    let temperature: Length?
}

// MARK: - Length
struct Length: Codable {
    let number: Int
    let unit: String
}

// MARK: - ExtendedIngredient
struct ExtendedIngredient: Codable {
    let id: Int?
    let aisle, image: String?
    let consistency: String?
    let name, original, originalString, originalName: String
    let amount: Double
    let unit: String
    let meta, metaInformation: [String]
    let measures: Measures
}

// MARK: - Measures
struct Measures: Codable {
    let us, metric: Metric
}

// MARK: - Metric
struct Metric: Codable {
    let amount: Double
    let unitShort, unitLong: String
}
