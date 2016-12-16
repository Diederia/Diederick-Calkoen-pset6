//
//  HomeViewController.swift
//  Diederick-Calkoen-pset6
//
//  Created by Diederick Calkoen on 07/12/16.
//  Copyright © 2016 Diederick Calkoen. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var textFieldRecipeSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!

    let id = String(globalStruct.userID!)
    var ref = FIRDatabase.database().reference()
    var recipeRef: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeRef = ref.child("users").child(id!).child("recipes")
        
        globalStruct.savedTitles.removeAll()
        globalStruct.savedUrls.removeAll()
        globalStruct.savedImages.removeAll()
        globalStruct.savedIngredients.removeAll()

        // Get data from firebase
        recipeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for child in result {
                    if let dictionary = child.value as? [String: AnyObject] {
                        
                        // Save data
                        let images = dictionary["image"]
                        let ingredients = dictionary["ingredients"]
                        let titles = dictionary["title"]
                        let urls = dictionary["url"]
                        globalStruct.savedImages.append(images as! String)
                        globalStruct.savedIngredients.append(ingredients as! String)
                        globalStruct.savedTitles.append(titles as! String)
                        globalStruct.savedUrls.append(urls as! String)
                    }
                }
            }
            // Reload table view
            self.performSelector(onMainThread: #selector(HomeViewController.reloadTableView), with: nil, waitUntilDone: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func searchDidTouch(_ sender: Any) {
        self.searchRecipe()
    }
    @IBAction func returnDidTouch(_ sender: Any) {
        self.searchRecipe()
    }
    
    @IBAction func logoutDidTouch(_ sender: Any) {
        print("test11")
        let alertController = UIAlertController(title: "Logout", message:
            "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: {
            (_)in
            try! FIRAuth.auth()!.signOut()
            self.performSegue(withIdentifier: "homeToLogin", sender: self)
        }))
        self.present(alertController, animated: true, completion: nil)
    }


    // MARK: Functions 
    func searchRecipe() {
        if textFieldRecipeSearch.text == "" {
            let alertController = UIAlertController(title: "No input provided", message:
                "Enter a recipe title or ingredient.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        } else {
            globalStruct.recipeSearchRequest = textFieldRecipeSearch.text!
            textFieldRecipeSearch.text = ""
            self.performSegue(withIdentifier: "searchToResults", sender: self)
        }
    }
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func clearSearchData() {
        globalStruct.recipeSearchRequest.removeAll()
        globalStruct.searchTitles.removeAll()
        globalStruct.searchImages.removeAll()
        globalStruct.searchUrls.removeAll()
        globalStruct.searchIngredients.removeAll()
    }
}

// MARK: - Table View
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalStruct.savedTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        
        cell.savedTitle.text = (globalStruct.savedTitles[indexPath.row])
        
        if (globalStruct.savedImages[indexPath.row] != "") {
            let image = (globalStruct.savedImages[indexPath.row])
            let urlImage = NSURL(string: image)
            let dataImage = NSData(contentsOf: urlImage! as URL)
            if dataImage != nil{
                cell.savedImage.image = UIImage(data: dataImage as! Data)
            } else {
                cell.savedImage.image = UIImage(named: "no-image")
            }
        }
        else {
            cell.savedImage.image = UIImage(named: "no-image")
            
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        globalStruct.currentIndex = indexPath.row
        self.performSegue(withIdentifier: "savedToRecipe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savedToRecipe" {
            let indexPath = tableView.indexPathForSelectedRow
            let destination = segue.destination as? RecipeViewController
            destination?.currentIndex = indexPath?.row
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == UITableViewCellEditingStyle.delete {
                
                // MARK: Remove from firebase
                let titleToDelete = globalStruct.savedTitles[indexPath.row]
                (recipeRef.child(String(titleToDelete))).removeValue()
                
                // MARK: Remove from glabal struct
                globalStruct.savedTitles.remove(at: indexPath.row)
                globalStruct.savedIngredients.remove(at: indexPath.row)
                globalStruct.savedImages.remove(at: indexPath.row)
                globalStruct.savedUrls.remove(at: indexPath.row)
                self.reloadTableView()
        }
    }
    
}

