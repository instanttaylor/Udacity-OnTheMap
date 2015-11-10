//
//  StudentLocationViewController.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/19/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit

class StudentLocationViewController: UIViewController {
    
    var studentLocationDataSource: ParseStudentLocationDataSource? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.studentLocationDataSource = ParseClient.sharedInstance().studentLocationDataSource
    }

}
