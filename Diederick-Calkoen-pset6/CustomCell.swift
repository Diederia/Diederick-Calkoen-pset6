//
//  CustomCell.swift
//  Diederick-Calkoen-pset6
//
//  Created by Diederick Calkoen on 08/12/16.
//  Copyright © 2016 Diederick Calkoen. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    // MARK: Outlets for saved recipes
    @IBOutlet weak var savedImage: UIImageView!
    @IBOutlet weak var savedTitle: UITextView!

    // MARK: Outlets for search recipes
    @IBOutlet weak var searchTitle: UITextView!
    @IBOutlet weak var searchImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
