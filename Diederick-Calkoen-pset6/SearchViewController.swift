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
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldRecipeSearch: UITextField!
    
    var searchRequest: String?
    var currentIndex: Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchRecipe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnDidTouch(_ sender: Any) {
        searchRecipe()
    }
    
    @IBAction func searchDidTouch(_ sender: Any) {
        searchRecipe()
    }
    
    // MARK: Functions
    func searchRecipe() {
        
        // MARK: Clear all global arrays of search
        self.clearSearchData()
        
        if textFieldRecipeSearch.text != "" {
            searchRequest = textFieldRecipeSearch.text?.replacingOccurrences(of: " ", with: "," )
        } else if globalStruct.recipeSearchRequest != "" {
            searchRequest = globalStruct.recipeSearchRequest.replacingOccurrences(of: " ", with: "," )
        } else {
            let alertController = UIAlertController(title: "No input provided", message:
                "Enter a recipe title or ingredient.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        // make url, also for search of more than one ingredient.

        
        // Source: http://www.learnswiftonline.com/mini-tutorials/how-to-download-and-read-json/
        let requestURL: NSURL = NSURL(string: "http://www.recipepuppy.com/api/?q=" + searchRequest!)!
        print("test1")
        print(requestURL)
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    
                    if (json["results"] as? String == "") {
                        // nog een alert maken
                        return
                    }
                    if let results = json["results"] as? [[String: AnyObject]] {

                        for result in results {
                            globalStruct.searchTitles.append((result["title"] as? String)!)
                            globalStruct.searchImages.append((result["thumbnail"] as? String)!)
                            globalStruct.searchUrls.append((result["href"] as? String)!)
                            globalStruct.searchIngredients.append((result["ingredients"] as? String)!)
                        }
                        self.performSelector(onMainThread: #selector(SearchViewController.reloadTableView), with: nil, waitUntilDone: true)
                    }
                } catch {
                    print ("Error with JSON: \(error)")
                }
            } else if (statusCode == 400) {
                let alertController = UIAlertController(title: "Error 400", message:
                    "The server cannot or will not process the request due to an apparent client error", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
                
            } else {
                let alertController = UIAlertController(title: "Error", message:
                    "Unknown error", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
        }
        
        task.resume()
        globalStruct.recipeSearchRequest.removeAll()
    }
    
    func clearSearchData() {
        globalStruct.currentIndex = 0
        globalStruct.searchTitles.removeAll()
        globalStruct.searchImages.removeAll()
        globalStruct.searchUrls.removeAll()
        globalStruct.searchIngredients.removeAll()
    }
    
    func reloadTableView() {
        if self.tableView != nil {
            self.tableView.reloadData()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Table View
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalStruct.searchTitles.count
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
        currentIndex = indexPath.row
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        globalStruct.currentIndex = indexPath.row
        self.performSegue(withIdentifier: "resultToRecipe", sender: self)
    }
}
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        let db = DatabaseHelper()
//        if editingStyle == UITableViewCellEditingStyle.delete {
//
//            let current = globalArrays.detailArray[indexPath.row]
//
//            do {
//                try db!.deleteToDo(id: idCurrentList, toDoName: current)
//            } catch {
//                print(error)
//            }
//            self.loadToDo(id: idCurrentList)
//            print(globalArrays.listArray)
//            self.loadView()
//            self.reloadTableView()
//        }
//    }
//}

