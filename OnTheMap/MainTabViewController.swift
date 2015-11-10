//
//  MainTabViewController.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/16/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    let db = Udacity.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = ParseClient.sharedInstance().studentLocationDataSource
        dataSource.refreshStudentLocations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let dataSource = ParseClient.sharedInstance().studentLocationDataSource
        dataSource.refreshStudentLocations()
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
        db.logout() { (success, error) in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print("ut oh, didn't log out")
            }
        }
    }
    
}
