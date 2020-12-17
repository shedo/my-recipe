//
//  SearchViewController+TableViewDelegate.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 10/12/20.
//

import Foundation
import UIKit

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell") as! SearchRecipeViewCell
        
        let recipe = recipes[indexPath.row]
        
        cell.recipeName.text = "\(recipe.title)"
        
        if let recipeImage = recipe.image {
            DispatchQueue.global(qos: .background).async {
                Client.downloadRecipeImage(path: recipeImage, completion: {(image, error) in
                    if error == nil {
                        guard let image = image else {
                            return
                        }
                        cell.setPhotoImageView(imageView: image, sizeFit: true)
                    }
                })
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "recipeDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
