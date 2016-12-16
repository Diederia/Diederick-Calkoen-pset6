//
//  GlobalStructs.swift
//  Diederick-Calkoen-pset6
//
//  Created by Diederick Calkoen on 08/12/16.
//  Copyright © 2016 Diederick Calkoen. All rights reserved.
//

import Foundation
import Firebase

struct globalStruct {
    
    // MARK: User info
    static var userEmail = FIRAuth.auth()?.currentUser?.email
    static var userID = FIRAuth.auth()?.currentUser?.uid
    
    // Mark: Tableview index
    static var currentIndex = Int()
    
    // MARK: Favorites info
    static var savedTitles: Array<String> = []
    static var savedImages: Array<String> = []
    static var savedUrls: Array<String> = []
    static var savedIngredients: Array<String> = []
    
    
    // MARK: Search info
    static var recipeSearchRequest = String()
    static var searchTitles: Array<String> = []
    static var searchImages: Array<String> = []
    static var searchUrls: Array<String> = []
    static var searchIngredients: Array<String> = []
    static var searchEmpty: Array<String> = []
    
    // MARK: Recipe info, IS DEZE WEL NODIG
     static var recipeTitle = String()
     static var recipeImage = String()
     static var recipeUrl = String()
     static var recipeIngredients = String()
}

