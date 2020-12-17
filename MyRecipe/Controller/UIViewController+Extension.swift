//
//  UIViewController+Extension.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 11/12/20.
//

import Foundation
import UIKit

extension UIViewController {
    
    static var spinner: UIActivityIndicatorView?
    
    func showAlertDialog(title:String, message: String, completionBlock:@escaping (_ okPressed:Bool)->()){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default) { (ok) in
            completionBlock(true)
        })
        present(alertVC, animated: true, completion:nil)
    }
    
    func showLoader(show: Bool) {
        if show {
            UIViewController.spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            UIViewController.spinner?.center = view.center
            UIViewController.spinner?.hidesWhenStopped = false
            UIViewController.spinner?.startAnimating()
            
            if let spinner = UIViewController.spinner {
                view.addSubview(spinner)
            }
        } else {
            UIViewController.spinner?.removeFromSuperview()
        }
    }
    
}
