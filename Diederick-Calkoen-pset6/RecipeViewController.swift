//
//  RecipeViewController.swift
//  Diederick-Calkoen-pset6
//
//  Created by Diederick Calkoen on 09/12/16.
//  Copyright © 2016 Diederick Calkoen. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    
    // MARK: Outlets
//    @IBOutlet weak var recipeTitle: UILabel!
//    @IBOutlet weak var recipeImage: UIImageView!
//    @IBOutlet weak var recipeIngredients: UITextView!
//    @IBOutlet weak var recipeURL: UITextView!
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var ingredientsText: UITextView!
    @IBOutlet weak var titleLabel: UITextView!
    
    
    var recipeTitle: String?
    var recipeURL: String?
    var recipeImage: String?
    var recipeIngredients: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if globalStruct.searchTitles.count != 0 {
            recipeTitle = globalStruct.searchTitles[globalStruct.currentIndex]
            recipeURL = globalStruct.searchUrls[globalStruct.currentIndex]
            recipeImage = globalStruct.searchImages[globalStruct.currentIndex]
            recipeIngredients = globalStruct.searchIngredients[globalStruct.currentIndex]
        } else {
            recipeTitle = globalStruct.savedTitles[globalStruct.currentIndex]
            recipeURL = globalStruct.savedUrls[globalStruct.currentIndex]
            recipeImage = globalStruct.savedImages[globalStruct.currentIndex]
            recipeIngredients = globalStruct.savedIngredients[globalStruct.currentIndex]
        }
        
        titleLabel.text = recipeTitle
        ingredientsText.text = recipeIngredients
        print(recipeIngredients!)
        
        print(recipeImage!)
        
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
        globalStruct.savedTitles.append(globalStruct.searchTitles[globalStruct.currentIndex])
        globalStruct.savedUrls.append(globalStruct.searchUrls[globalStruct.currentIndex])
        globalStruct.savedImages.append(globalStruct.searchImages[globalStruct.currentIndex])
        globalStruct.savedIngredients.append(globalStruct.searchIngredients[globalStruct.currentIndex])
        
        self.performSegue(withIdentifier: "recipeToHome", sender: self)
    }
    
    @IBAction func toWebsiteDidTouch(_ sender: Any) {
        if let url = NSURL(string: recipeURL!) {
            UIApplication.shared.openURL(url as URL)
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
