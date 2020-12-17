//
//  RecipeDetailViewController.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 10/12/20.
//

import UIKit
import CoreData

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeCookingTime: UILabel!
    @IBOutlet weak var recipeIngredients: UITableView!
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    @IBOutlet weak var saveRecipe: UIBarButtonItem!
    @IBOutlet weak var viewInstructions: UIButton!
    @IBOutlet weak var recipeTitle: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedRecipe: Recipe!
    var isFavorite: Bool = false
    var recipeImg: UIImage!
    var savedRecipe: SavedRecipe!
    var savedIngedients: [Ingredient] = []
    var savedInstruction: [Instruction] = []
    var recipeDetail: RecipeDetailResponse!
    var recipeInstructionsList: [AnalyzedInstruction] = []
    var recipeIngredientsList: [ExtendedIngredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if savedRecipe != nil {
            setupFetchRequest()
            self.isFavorite = true
        } else if selectedRecipe != nil {
            self.isFavorite = checkIfItemExist(id: selectedRecipe.id ?? 0)
            if(isFavorite) {
                setupFetchSavedRecipeRequest()
            } else {
                loadDataFromWeb()
            }
        } else if recipeDetail != nil {
            self.initPageData()
            self.isFavorite = checkIfItemExist(id: recipeDetail.id)
        }
        self.imageLoader.isHidden = true
        self.recipeIngredients.allowsSelection = false
        self.toggleBarButton(saveRecipe, enabled: self.isFavorite)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedRecipe = nil
        isFavorite = false
        recipeImg = nil
        savedRecipe = nil
        savedIngedients = []
        recipeDetail = nil
        recipeInstructionsList = []
        recipeIngredientsList = []
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func loadDataFromWeb() {
        self.imageLoader.isHidden = false
        self.imageLoader.startAnimating()
        self.showLoader(show: true)
        if let recipePath = selectedRecipe.image {
            Client.downloadRecipeImage(path: recipePath) { image, error in
                if error == nil {
                    guard let image = image else {
                        return
                    }
                    self.imageLoader.isHidden = true
                    self.imageLoader.stopAnimating()
                    self.recipeImg = image
                } else {
                    self.showAlertDialog(title: "Error", message: error?.localizedDescription ?? "") { (value) in
                        return
                    }
                }
            }
        }
            
        if let recipeId = selectedRecipe.id {
            Client.getRecipeDetail(recipeId: String(recipeId), completion: { (recipeResponse, error) in
                if error == nil {
                    guard let recipeDetail = recipeResponse else {
                        return
                    }
                    self.recipeDetail = recipeDetail
                    self.showLoader(show: false)
                    self.initPageData()
                } else {
                    self.showAlertDialog(title: "Error", message: error?.localizedDescription ?? "") { (value) in
                        return
                    }
                }
            })
        }
    }
    
    private func setupFetchSavedRecipeRequest() {
        let id = savedRecipe != nil ? Int(savedRecipe.id) : selectedRecipe.id ?? 0
        let fetchSavedRecipeRequest: NSFetchRequest<SavedRecipe> = SavedRecipe.fetchRequest()
        let predicate = NSPredicate(format: "id == %d" ,id)

        fetchSavedRecipeRequest.predicate = predicate
        if let result = try? appDelegate.dataController.viewContext.fetch(fetchSavedRecipeRequest) {
            savedRecipe = result[0]
            setupFetchRequest()
        }
    }
    
    private func setupFetchRequest() {
        let fetchIngredientRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        let fetchInstructionRequest: NSFetchRequest<Instruction> = Instruction.fetchRequest()
        
        let predicate = NSPredicate(format: "savedRecipe == %@", savedRecipe)
        let sort = NSSortDescriptor(key: "stepNumber", ascending: true)

        fetchIngredientRequest.predicate = predicate
        
        fetchInstructionRequest.sortDescriptors = [sort]
        fetchInstructionRequest.predicate = predicate
        
        if let result = try? appDelegate.dataController.viewContext.fetch(fetchIngredientRequest) {
            savedIngedients = result
            self.initSavedData()
        }
        
        if let result = try? appDelegate.dataController.viewContext.fetch(fetchInstructionRequest) {
            savedInstruction = result
        }
    }
    
    func initSavedData() {
        self.recipeCookingTime.text = "Ready in \(self.savedRecipe.timeRequired) minutes"
        self.recipeTitle.text = self.savedRecipe.title
        if let image = self.savedRecipe.image {
            self.recipeImage.image = UIImage(data: image)
        }
        self.recipeIngredients.reloadData()
    }
    
    func initPageData() {
        self.recipeInstructionsList = self.recipeDetail.analyzedInstructions!
        self.recipeIngredientsList = self.recipeDetail.extendedIngredients!
        self.recipeCookingTime.text = "Ready in \(self.recipeDetail.readyInMinutes) minutes"
        self.recipeTitle.text = self.recipeDetail.title
        self.recipeImage.image = recipeImg
        self.recipeIngredients.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeInstruction" {
            let recipeInstructionVC = segue.destination as! InstructionViewController
            if !isFavorite {
                recipeInstructionVC.recipeInstructionsList = self.recipeInstructionsList
            } else {
                recipeInstructionVC.savedInstructionList = self.savedInstruction
            }
        }
    }
    
    @IBAction func saveRecipe(_ sender: Any) {
        let managedContext = self.appDelegate.dataController.viewContext

        if !self.isFavorite  {
            createSavedRecipe(recipeDetail: recipeDetail)
            self.isFavorite = true
            self.toggleBarButton(saveRecipe, enabled: true)
        } else {
            let id = savedRecipe != nil ? Int(savedRecipe.id) : recipeDetail.id
            let deleteRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedRecipe")
            deleteRequest.predicate = NSPredicate(format: "id == %d" ,id)
            deleteRequest.returnsObjectsAsFaults = false
            
            do {
                let arrUsrObj = try managedContext.fetch(deleteRequest)
                for usrObj in arrUsrObj {
                    managedContext.delete(usrObj)
                }
            } catch {
                print("Failed")
            }
            
            self.isFavorite = false
            self.toggleBarButton(saveRecipe, enabled: false)
        }
        
        do {
            try managedContext.save()
            if self.isFavorite {
                self.showAlertDialog(title: "Recipe Saved", message: "") { (value) in
                    return
                }
            } else {
                self.showAlertDialog(title: "Recipe removed", message: "") { (value) in
                    if self.recipeDetail == nil {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } catch {
            self.showAlertDialog(title: "Unable to save the recipe", message: "") { (value) in
                return
            }
        }
    }
    
    @IBAction func viewInstruction(_ sender: Any) {
        if self.recipeInstructionsList.count == 0 && self.savedInstruction.count == 0 {
            self.showAlertDialog(title: "Instructions Unavailable", message: "") { (value) in
                return
            }
        } else {
            performSegue(withIdentifier: "recipeInstruction", sender: nil)
        }
    }
    
    @IBAction func shareRecipe(_ sender: Any) {
        guard let recipeUrlStr = savedRecipe != nil ? savedRecipe.url : recipeDetail.spoonacularSourceUrl else { return }
        let recipeUrl = NSURL(string:recipeUrlStr)
        let linkToShare = [ recipeUrl! ]
        let activityViewController = UIActivityViewController(activityItems: linkToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func toggleBarButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.image = UIImage(named: "Favorite")
        } else {
            button.image = UIImage(named: "FavoriteDeselected")
        }
    }
    
    func checkIfItemExist(id: Int) -> Bool {
        let managedContext = self.appDelegate.dataController.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedRecipe")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d" ,id)

        do {
            let count = try managedContext.count(for: fetchRequest)
            if count > 0 {
                return true
            }else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func createSavedRecipe(recipeDetail: RecipeDetailResponse) {
        let foodRecipe = SavedRecipe(context: appDelegate.dataController.viewContext)
        foodRecipe.id = Int64(recipeDetail.id)
        foodRecipe.title = recipeDetail.title
        foodRecipe.timeRequired = Int64(recipeDetail.readyInMinutes)
        foodRecipe.url = recipeDetail.spoonacularSourceUrl
        foodRecipe.image =  self.recipeImg.pngData()
            
        if self.recipeIngredientsList.count != 0 {
            for ingredientDetail in self.recipeIngredientsList {
                let ingredient = Ingredient(context: appDelegate.dataController.viewContext)
                ingredient.name = ingredientDetail.name
                ingredient.originalName = ingredientDetail.originalName
                ingredient.imagePath = ingredientDetail.image
                ingredient.savedRecipe = foodRecipe
            }
        }
        
        if self.recipeInstructionsList.count != 0 {
            if self.recipeInstructionsList[0].steps.count != 0 {
                for steps in self.recipeInstructionsList[0].steps {
                    let instruction = Instruction(context: appDelegate.dataController.viewContext)
                    instruction.instruction = steps.step
                    instruction.stepNumber = Int64(steps.number)
                    instruction.savedRecipe = foodRecipe
                }
            }
        }
        self.savedRecipe = foodRecipe
    }
    
}
