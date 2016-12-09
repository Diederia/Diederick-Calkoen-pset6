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

    var currentIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadTableView()
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
        if self.tableView != nil {
            self.tableView.reloadData()
        }
    }
    func updateStorage() {

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
        currentIndex = indexPath.row
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        currentIndex = indexPath.row
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let recipeVC = segue.destination as! RecipeViewController
//        recipeVC.recipeTitle = self.titles[self.tableView.indexPathForSelectedRow!.row]
//        recipeVC.recipeURL = self.urls[self.tableView.indexPathForSelectedRow!.row]
//        recipeVC.recipeImage = self.images[self.tableView.indexPathForSelectedRow!.row]
//        recipeVC.recipeIngredients = self.ingredients[self.tableView.indexPathForSelectedRow!.row]
//    }
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
