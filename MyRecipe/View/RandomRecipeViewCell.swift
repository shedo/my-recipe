//
//  RandomRecipeViewCell.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 13/12/20.
//

import UIKit

class RandomRecipeViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var downloadImage: UIActivityIndicatorView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    static let reuseIdentifier = "RecipeAlbumViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        downloadImage.isHidden = false
        downloadImage.startAnimating()
    }
    
    func setPhotoImageView(imageView: UIImage, sizeFit: Bool) {
        
        recipeImageView.image = imageView
        if sizeFit == true {
            recipeImageView.sizeToFit()
        }
        
        downloadImage.isHidden = true
        downloadImage.stopAnimating()
    }
}

