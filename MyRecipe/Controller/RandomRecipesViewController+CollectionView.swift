//
//  RandomRecipesViewController+CollectionView.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 13/12/20.
//

import UIKit

extension RandomRecipesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = randomRecipesList.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomRecipeViewCell.reuseIdentifier, for: indexPath as IndexPath) as! RandomRecipeViewCell
        guard !(self.randomRecipesList.count == 0) else {
            return cell
        }
        
        let recipeDetail = self.randomRecipesList[indexPath.row]
        cell.recipeTitle.text = recipeDetail.title
        
        DispatchQueue.global(qos: .background).async {
            Client.getRecipeImage(recipeId: String(recipeDetail.id), completion: {(image, error) in
                if error == nil {
                    guard let image = image else {
                        return
                    }
                    cell.setPhotoImageView(imageView: image, sizeFit: true)
                }
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetailFromRandom", sender: nil)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 3.0
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
    }
}
