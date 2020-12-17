# My Recipe


## Origin
This app is my Capstone project for the iOS Developer Nanodegree offered by Udacity. This Nanodegree course focuses on iOS app development using Swift, including UIKit Fundamentals, Networking, and Persistence with Code Data.
The app lets a user to search recipes through [Spoonacular API](https://spoonacular.com) and enable users to save favourite recipes in their app offline.

## About the App
When the application starts, you land on the home screen which shows suggested dishes (generated randomly). In the second screen of the bottom tabbar it is possible to search for dishes by entering the name and pressing the "Enter" key (to reduce the calls to the API). Clicking one of the results will land in the detail of the dish, in which will be displayed: the images, cooking time, ingredients and three buttons, one to save the dish in the favorites (local DB), one to share the link of the dish and one to see the instructions.
In the third tab of the bottom tabbar there is the list of saved dishes, by clicking it will be possible to view the detail of the dish and decide whether to remove it from the favorites.

## Features

* Tips of the Day (Random recipe) - RandomRecipeViewController
* Search and find recipes from API (Spoonacular) - SearchViewController
* Save Favorite recipes to local database - MyFavoriteRecipeViewController
* View recipe detail (Photo, Cooking time, Ingredients and Instruction) - RecipeDetailViewController
* Share recipe by Spoonacular link - RecipeDetailViewController

## Libraries and Frameworks Used
**iOS Frameworks**:
1. [Foundation](https://developer.apple.com/documentation/foundation)
2. [UIKit](https://developer.apple.com/documentation/uikit)
3. [Core Data](https://developer.apple.com/documentation/coredata) to store images.

**External Library**
4. [Alamofire](https://github.com/Alamofire/Alamofire) to make HTTP request.

## How to Build
The build system uses [CocoaPods](https://cocoapods.org) to integrate dependencies. You should be familiar with CocoaPods and API key and secret from Flickr account.
1. Download zip or fork & clone project on your desktop.
2. Open Terminal and `cd` into project folder.
3. Run `pods install` to install dependencies.
4. Open `MyRecipe.xcworkspace` with Xcode.
5. Now you can build and run the app.
