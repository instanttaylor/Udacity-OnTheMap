//
//  ParseStudentLocationDataSource.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/19/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation
import UIKit

class ParseStudentLocationDataSource: NSObject {
    
    var studentLocations = [ParseStudentLocation]()
    let nc = NSNotificationCenter.defaultCenter()
    
//    set up will refresh, did refresh notifications, and error notifications
    
//    make refresh student data method, calls the parse get locations method
    
    func refreshStudentLocations() {
        
        ParseClient.sharedInstance().getStudentLocations { studentResults, error in
            if let studentLocations = studentResults {
                self.studentLocations = studentLocations
            } else {
                print("in refresh students: \(error)")
                self.nc.postNotificationName("parseDownloadFail", object: nil)
            }
        }
    }
}

extension ParseStudentLocationDataSource: UITableViewDataSource {
   // do the tableview stuff like set up the cell
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableview count: \(self.studentLocations.count)")
        return self.studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = studentLocations[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as UITableViewCell!
        cell.textLabel?.text = "\(student.firstName as String!) \(student.lastName as String!)"
        
        return cell
    }
    
}