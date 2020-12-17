//
//  IngredientViewCell.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 16/12/20.
//

import UIKit

class IngredientViewCell: UITableViewCell {
    @IBOutlet weak var ingredientImage: UIImageView!
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var ingredientDescription: UILabel!
    @IBOutlet weak var downloadImage: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientImage.image = nil
        ingredientName.text = nil
        ingredientDescription.text = nil
        downloadImage.isHidden = false
        downloadImage.startAnimating()
    }
    
    func setPhotoImageView(imageView: UIImage, sizeFit: Bool) {
        
        ingredientImage.image = imageView
        if sizeFit == true {
            ingredientImage.sizeToFit()
        }
        
        downloadImage.isHidden = true
        downloadImage.stopAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
