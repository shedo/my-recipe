//
//  FavoriteRecipeViewCell.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 16/12/20.
//

import UIKit

class FavoriteRecipeViewCell: UITableViewCell {
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImage.image = nil
        recipeName.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
