//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/2/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let db = Udacity.sharedInstance()
    let parse = ParseClient.sharedInstance()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        db.authWithUdacity(emailField.text!, password: passwordField.text!) { (success, error) -> Void in
            if success {
                self.loadApp()
            } else {
                if let error = error?.userInfo["NSLocalizedDescription"] as? String {
                    dispatch_async(dispatch_get_main_queue()) {
                        let ac = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                        ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(ac, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func loadApp() {
        dispatch_async(dispatch_get_main_queue()) {
            let con = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
            self.presentViewController(con, animated: true, completion: nil)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
}

