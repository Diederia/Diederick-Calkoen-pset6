//
//  LoginViewController.swift
//  Diederick-Calkoen-pset6
//
//  Created by Diederick Calkoen on 07/12/16.
//  Copyright © 2016 Diederick Calkoen. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions funtions
    @IBAction func loginDidTouch(_ sender: Any) {
            FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
                                   password: textFieldLoginPassword.text!) {
                (user, error) in
                if error != nil {
                    self.alertError()
                }
                self.performSegue(withIdentifier: "toHomeView", sender: self)
        }
    }
    
    @IBAction func registerDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "toRegisterView", sender: self)
    }

    // MARK: Alert function
    func alertError() {
        let alertController = UIAlertController(title: "Error with loggig in", message:
            "Enter a valid email and password.", preferredStyle: UIAlertControllerStyle.alert)
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