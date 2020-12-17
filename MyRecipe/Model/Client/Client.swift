//
//  Client.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 07/12/20.
//

import Foundation
import Alamofire
import AlamofireImage

class Client {
    
    static let apiKey = "3784f7835f8a4311b66cb4ede4dbbb91"
    
    enum Endpoints {
        static let base = "https://api.spoonacular.com/recipes"
        static let baseImage = "https://spoonacular.com"
        static let apiKeyParam = "?apiKey=\(Client.apiKey)"
        static let cusineType = "italian"
        static let numberOfRandomRecipe = "20"

        case randomRecipe
        case searchRecipe(String)
        case getRecipeInformation(String)
        case getRecipeImage(String)
        case getIngredientImage(String)
        
        var stringValue: String {
            switch self {
            case .randomRecipe:
                return Endpoints.base + "/random" + Endpoints.apiKeyParam + "&limitLicense=true&tags=\(Endpoints.cusineType)&number=\(Endpoints.numberOfRandomRecipe)"
            case .searchRecipe(let query):
                return Endpoints.base + "/complexSearch" + Endpoints.apiKeyParam + "&cuisine=" + Endpoints.cusineType + "&limitLicense=true" + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            case .getRecipeInformation(let recipeId):
                return Endpoints.base + "/" + recipeId + "/information" + Endpoints.apiKeyParam +  "&includeNutrition=false"
            case .getIngredientImage(let imageName):
                return Endpoints.baseImage + "/cdn/ingredients_100x100/" + imageName
            case .getRecipeImage(let recipeId):
                return Endpoints.baseImage + "/recipeImages/\(recipeId)-556x370.jpg"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> Void {
        AF.request(url).response { response in
            guard let data = response.data else { return }
            let decoder = JSONDecoder()

            switch response.result {
            case .success:
                do {
                    let responseObject = try decoder.decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let error{
                    print(error)
                    do {
                        let errorResponse = try decoder.decode(SpoonacularResponse.self, from: data) as Error
                        DispatchQueue.main.async {
                            completion(nil, errorResponse)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    class func getRandomRecipe(completion: @escaping ([RecipeDetailResponse], Error?) -> Void) -> Void {
        taskForGETRequest(url: Endpoints.randomRecipe.url, responseType: RandomRecipeResponse.self) { response, error in
            if let response = response {
                completion(response.recipes, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func search(query: String, completion: @escaping ([Recipe], Error?) -> Void) -> Void {
        taskForGETRequest(url: Endpoints.searchRecipe(query).url, responseType: SearchResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getRecipeDetail(recipeId: String, completion: @escaping (RecipeDetailResponse?, Error?) -> Void) -> Void {
        taskForGETRequest(url: Endpoints.getRecipeInformation(recipeId).url, responseType: RecipeDetailResponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func downloadRecipeImage(path: String, completion: @escaping (UIImage?, Error?) -> Void) {
        AF.request(path).responseImage { response in
            switch response.result {
            case .success(let image):
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    class func downloadIngredientImage(imageName: String, completion: @escaping (UIImage?, Error?) -> Void) {
        AF.request(Endpoints.getIngredientImage(imageName).url).responseImage { response in
            switch response.result {
            case .success(let image):
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    class func getRecipeImage(recipeId: String, completion: @escaping (UIImage?, Error?) -> Void) {
        AF.request(Endpoints.getRecipeImage(recipeId).url).responseImage { response in
            switch response.result {
            case .success(let image):
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    class func cancelRequests() {
        AF.session.getTasksWithCompletionHandler({ dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        })
    }
    
}
