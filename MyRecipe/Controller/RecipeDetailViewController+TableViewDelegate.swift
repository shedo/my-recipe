//
//  RecipeDetailViewController+TableViewDelegate.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 13/12/20.
//

import Foundation
import UIKit

extension RecipeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavorite {
            return savedIngedients.count
        } else {
            return recipeIngredientsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeIngredientViewCell") as! IngredientViewCell
        
        var ingredientName = ""
        var ingredientOriginalName = ""
        var ingredientImagePath: String?
        
        if !isFavorite {
            let recipeIngredient = recipeIngredientsList[indexPath.row]
            ingredientName = recipeIngredient.name
            ingredientOriginalName = recipeIngredient.original
            ingredientImagePath = recipeIngredient.image!
        } else {
            let savedRecipeIngredient = savedIngedients[indexPath.row]
            ingredientName = savedRecipeIngredient.name ?? ""
            ingredientOriginalName = savedRecipeIngredient.originalName ?? ""
            ingredientImagePath = savedRecipeIngredient.imagePath
        }
        
        cell.ingredientName.text = "\(ingredientName)"
        cell.ingredientDescription.text = "\(ingredientOriginalName)"
        if let ingredientPath = ingredientImagePath {
            Client.downloadIngredientImage(imageName: ingredientPath) { image, error in
                guard let image = image else {
                    return
                }
                cell.setPhotoImageView(imageView: image, sizeFit: true)
                cell.setNeedsLayout()
            }
        }
        
        return cell
    }
    
}
