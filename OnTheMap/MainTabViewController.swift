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
    let nc = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = ParseClient.sharedInstance().studentLocationDataSource
        dataSource.refreshStudentLocations()
        nc.addObserver(self, selector: "alertFailedDownload", name: "parseDownloadFail", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let dataSource = ParseClient.sharedInstance().studentLocationDataSource
        dataSource.refreshStudentLocations()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func alertFailedDownload() {
        dispatch_async(dispatch_get_main_queue()) {
            let ac = UIAlertController(title: "Ooops", message: "Failed to get student locations from parse", preferredStyle: UIAlertControllerStyle.Alert)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        }
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
