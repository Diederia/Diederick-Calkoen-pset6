//
//  RegsiterViewController.swift
//  Diederick-Calkoen-pset6
//
//  Created by Diederick Calkoen on 08/12/16.
//  Copyright © 2016 Diederick Calkoen. All rights reserved.
//

import UIKit
import Firebase

class RegsiterViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var textFieldRegisterEmail: UITextField!
    @IBOutlet weak var textFieldRegisterPassword: UITextField!
    @IBOutlet weak var textFieldRegisterConfirm: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Register funtion
    @IBAction func registerDidTOuch(_ sender: Any) {
        
        // Check input
        guard textFieldRegisterEmail.text! != "" && textFieldRegisterPassword.text! != "" && textFieldRegisterConfirm.text! != "" else {
            self.alert(title: "Error to register", message: "Enter a valid email, password and confrim password.\n Your password needs to be at least 6 character long.")
            return
        }
        
        guard textFieldRegisterPassword.text!.characters.count >= 6 else {
            self.alert(title: "Error to register", message: "Your password needs to be at least 6 character long." )
            return
        }
        
        guard textFieldRegisterPassword.text! == textFieldRegisterConfirm.text! else {
            self.alert(title: "Error to register", message: "The passwords do not match" )
            return
        }
        
        // Save user in firebase
        FIRAuth.auth()!.createUser(withEmail: self.textFieldRegisterEmail.text!, password: textFieldRegisterPassword.text!) { (user, error) in
            if error != nil {
                self.alert(title: "Error to register", message: "Error with database")
                return
            }
            FIRAuth.auth()!.signIn(withEmail: self.textFieldRegisterEmail.text!, password: self.textFieldRegisterPassword.text!)
        }

        // Registering completed
        let alertController = UIAlertController(title: "Registering compeleted", message: "You are now registered", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: {
            (_)in
            self.performSegue(withIdentifier: "registerToHomeView", sender: self)
        })
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Cancel function
    @IBAction func cancelDidTouch(_ sender: Any) {
        let alertController = UIAlertController(title: "Cancel registering", message: "Are you sure you want to cancel registering?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:  {
            (_)in
            self.performSegue(withIdentifier: "registerToLoginView", sender: self)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Alert function
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
