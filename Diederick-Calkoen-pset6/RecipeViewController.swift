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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var urlText: UITextView!
    @IBOutlet weak var ingredientsText: UITextView!
    
    
    var recipeTitle: String?
    var recipeURL: String?
    var recipeImage: String?
    var recipeIngredients: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTitle = globalStruct.searchTitles[globalStruct.currentIndex]
        recipeURL = globalStruct.searchUrls[globalStruct.currentIndex]
        recipeImage = globalStruct.searchImages[globalStruct.currentIndex]
        recipeIngredients = globalStruct.searchIngredients[globalStruct.currentIndex]
        
        titleLabel.text = recipeTitle
        urlText.text = recipeURL
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
        
        globalStruct.savedTitles = [globalStruct.searchTitles[globalStruct.currentIndex]]
        globalStruct.savedUrls = [globalStruct.searchUrls[globalStruct.currentIndex]]
        globalStruct.savedImages = [globalStruct.searchImages[globalStruct.currentIndex]]
        globalStruct.savedIngredients = [globalStruct.searchIngredients[globalStruct.currentIndex]]
        
        self.performSegue(withIdentifier: "recipeToHome", sender: self)
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
