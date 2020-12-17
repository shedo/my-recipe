//
//  SearchRecipeViewCell.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 16/12/20.
//

import UIKit

class SearchRecipeViewCell: UITableViewCell {
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var downloadImage: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImage.image = nil
        recipeName.text = nil
        downloadImage.isHidden = false
        downloadImage.startAnimating()
    }
    
    func setPhotoImageView(imageView: UIImage, sizeFit: Bool) {
        
        recipeImage.image = imageView
        if sizeFit == true {
            recipeImage.sizeToFit()
        }
        
        downloadImage.isHidden = true
        downloadImage.stopAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
