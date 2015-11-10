//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/19/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit

class StudentListViewController: StudentLocationViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView!.dataSource = self.studentLocationDataSource
        self.tableView!.delegate = self
        
        self.tableView.reloadData()

        // Do any additional setup after loading the view.
    }
}

extension StudentListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var canOpen = false
        let app = UIApplication.sharedApplication()
        
        guard let data = studentLocationDataSource?.studentLocations else {return}
        let student = data[indexPath.row]
    
        guard let canOpenURL = NSURL(string: student.mediaURL) else {return}
        canOpen = app.canOpenURL(canOpenURL)
        
        if canOpen {
            app.openURL(canOpenURL)
        } else {
            let alertView = UIAlertController(title: "Ooops", message: "Bad link", preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
}