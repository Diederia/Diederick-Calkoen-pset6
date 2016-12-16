//
//  SearchViewController.swift
//  Diederick-Calkoen-pset6
//
//  Created by Diederick Calkoen on 08/12/16.
//  Copyright © 2016 Diederick Calkoen. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldRecipeSearch: UITextField!
    
    // MARK: Variables
    var noResult = Bool(false)
    var searchRequest: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchRecipe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func returnDidTouch(_ sender: Any) {
        searchRecipe()
    }
    
    @IBAction func searchDidTouch(_ sender: Any) {
        searchRecipe()
    }
    
    // MARK: Functions
    func searchRecipe() {
        
        // Clear all search global arrays
        self.clearSearchData()
        
        // Configurate search request string, if there is no input so alert
        if textFieldRecipeSearch.text != "" {
            searchRequest = textFieldRecipeSearch.text?.replacingOccurrences(of: " ", with: "," )
        } else if globalStruct.recipeSearchRequest != "" {
            searchRequest = globalStruct.recipeSearchRequest.replacingOccurrences(of: " ", with: "," )
        } else {
            self.alert(title: "No input provided", message: "Enter a recipe title or ingredient.")
        }
        
        
        // JSON request
        // Source: http://www.learnswiftonline.com/mini-tutorials/how-to-download-and-read-json/
        let requestURL: NSURL = NSURL(string: "http://www.recipepuppy.com/api/?q=" + searchRequest!)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary

                    if let results = json["results"] as? [[String: AnyObject]] {
                            for result in results {
                                globalStruct.searchTitles.append((result["title"] as? String)!)
                                globalStruct.searchImages.append((result["thumbnail"] as? String)!)
                                globalStruct.searchUrls.append((result["href"] as? String)!)
                                globalStruct.searchIngredients.append((result["ingredients"] as? String)!)
                        }
                        // Reload table view
                        self.performSelector(onMainThread: #selector(SearchViewController.reloadTableView), with: nil, waitUntilDone: true)
                    }
                } catch {
                    print ("Error with JSON: \(error)")
                }
            } else if (statusCode == 400) {
                self.alert(title: "Error 400", message: "The server cannot or will not process the request due to an apparent client error")
            } else {
                self.alert(title: "Error", message: "Unknown error")
            }
        }
        task.resume()
        textFieldRecipeSearch.text = ""
        globalStruct.recipeSearchRequest.removeAll()
    }
    
    func clearSearchData() {
        globalStruct.searchTitles.removeAll()
        globalStruct.searchImages.removeAll()
        globalStruct.searchUrls.removeAll()
        globalStruct.searchIngredients.removeAll()
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}

// MARK: - Table View
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = globalStruct.searchTitles.count
        
        // Alert when there is no result
        if numberOfRows == 0 {
            self.alert(title: "Not found", message: "There is no recipe found, please enter a ingredient or recipe name.")
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        
        cell.searchTitle.text = (globalStruct.searchTitles[indexPath.row])
        
        if (globalStruct.searchImages[indexPath.row] != "") {
            let image = (globalStruct.searchImages[indexPath.row])
            let urlImage = NSURL(string: image)
            let dataImage = NSData(contentsOf: urlImage! as URL)
            if dataImage != nil{
                cell.searchImage.image = UIImage(data: dataImage as! Data)
            } else {
                cell.searchImage.image = UIImage(named: "no-image")
            }
        }
        else {
            cell.searchImage.image = UIImage(named: "no-image")
            
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        globalStruct.currentIndex = indexPath.row
        self.performSegue(withIdentifier: "resultToRecipe", sender: self)
    }
}


