//
//  RecipeViewController.swift
//  Diederick-Calkoen-pset6
//
//  Created by Diederick Calkoen on 09/12/16.
//  Copyright © 2016 Diederick Calkoen. All rights reserved.
//

import UIKit
import Firebase

class RecipeViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var ingredientsText: UITextView!
    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var saveButton: UIButton!

    
    var ref = FIRDatabase.database().reference()
    var recipeTitle: String?
    var recipeURL: String?
    var recipeImage: String?
    var recipeIngredients: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: From search to single recipe
        if globalStruct.searchTitles.count != 0 {
            self.saveButton.isHidden = false
            recipeTitle = globalStruct.searchTitles[globalStruct.currentIndex]
            recipeURL = globalStruct.searchUrls[globalStruct.currentIndex]
            recipeImage = globalStruct.searchImages[globalStruct.currentIndex]
            recipeIngredients = globalStruct.searchIngredients[globalStruct.currentIndex]
            
        // MARK: From saved to single recipe
        } else {
            self.saveButton.isHidden = true
            recipeTitle = globalStruct.savedTitles[globalStruct.currentIndex]
            recipeURL = globalStruct.savedUrls[globalStruct.currentIndex]
            recipeImage = globalStruct.savedImages[globalStruct.currentIndex]
            recipeIngredients = globalStruct.savedIngredients[globalStruct.currentIndex]
        }
        
        titleLabel.text = recipeTitle
        ingredientsText.text = recipeIngredients
        
        if (recipeImage != "") {
            let image = recipeImage!
            let urlImage = NSURL(string: image)
            let dataImage = NSData(contentsOf: urlImage! as URL)
            if (dataImage != nil) {
                bannerImage.image = UIImage(data: dataImage as! Data)
            } else {
                bannerImage.image = UIImage(named: "no-image")
            }
        }else {
            bannerImage.image = UIImage(named: "no-image")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func favoriteDidTouch(_ sender: Any) {
        
//        let user = "\(globalStruct.userEmail!)"
        let id = "\(globalStruct.userID!)"
        let title = "\(globalStruct.searchTitles[globalStruct.currentIndex])"
        let url = "\(globalStruct.searchUrls[globalStruct.currentIndex])"
        let image = "\(globalStruct.searchImages[globalStruct.currentIndex])"
        let ingredients = "\(globalStruct.searchIngredients[globalStruct.currentIndex])"
        
        self.ref.child("users").child(id).child("recipes").child(title).setValue(["title":title, "url":url, "image":image, "ingredients": ingredients])
        
        globalStruct.searchTitles.removeAll()
        self.performSegue(withIdentifier: "recipeToHome", sender: self)
    }
    
    @IBAction func toWebsiteDidTouch(_ sender: Any) {
        if let url = NSURL(string: recipeURL!) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
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
