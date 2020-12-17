//
//  SearchViewController.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 04/12/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var recipes = [Recipe]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var selectedIndex = 0
    
    var currentSearchTask: URLSessionDataTask?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeDetail" {
            let recipeDetailVC = segue.destination as! RecipeDetailViewController
            recipeDetailVC.selectedRecipe = recipes[selectedIndex]
        }
    }
    
}
