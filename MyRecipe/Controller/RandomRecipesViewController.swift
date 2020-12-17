//
//  RandomRecipesViewController.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 13/12/20.
//

import UIKit

class RandomRecipesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var randomRecipesList: [RecipeDetailResponse] = []
    var selectedIndex = 0
    let columnsPerRow = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
        self.showLoader(show: true)
        Client.getRandomRecipe {(recipes, error) in
            if error == nil {
                self.randomRecipesList = recipes
                self.showLoader(show: false)
                self.collectionView.reloadData()
            } else {
                self.showAlertDialog(title: "Error", message: error?.localizedDescription ?? "") { (value) in
                    return
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailFromRandom" {
            let recipeDetailVC = segue.destination as! RecipeDetailViewController
            let indexPath = IndexPath(item: selectedIndex, section: 0)
            let cell = self.collectionView.cellForItem(at: indexPath) as! RandomRecipeViewCell
            recipeDetailVC.recipeDetail = randomRecipesList[selectedIndex]
            recipeDetailVC.recipeImg = cell.recipeImageView.image
        }
    }
}
