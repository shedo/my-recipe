//
//  SearchViewController+SearchBarDelegate.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 10/12/20.
//

import Foundation
import UIKit

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Client.cancelRequests()
        if !(searchBar.text ?? "").isEmpty {
            self.showLoader(show: true)
            Client.search(query: searchBar.text ?? "") { recipes, error in
                if error == nil {
                    self.recipes = recipes
                    DispatchQueue.main.async {
                        self.showLoader(show: false)
                        self.tableView.reloadData()
                    }
                } else {
                    self.showAlertDialog(title: "Error", message: error?.localizedDescription ?? "" ) { (value) in
                        return
                    }
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.recipes = []
        self.tableView.reloadData()
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
}
