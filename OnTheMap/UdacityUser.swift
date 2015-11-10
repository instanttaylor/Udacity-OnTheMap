//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/12/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation

struct UdacityUser {
    var firstName: String? = nil
    var lastName: String? = nil
    var user_id: String? = nil
    var fullName: String {
        get {
            if firstName != nil && lastName != nil {
                return firstName! + " " + lastName!
            } else {
                return ""
            }
        }
    }
    
    init() {
        firstName = "n/a"
        lastName = "n/a"
        user_id = "n/a"
    }
}