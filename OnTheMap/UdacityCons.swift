//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/9/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation

extension Udacity {
    struct Constants {  
        static let baseSecureURL = "https://www.udacity.com/api/"
    }
    
    struct Methods {
        static let session = "session"
        static let deleteSession = "session"
        static let getUserData = "users/{user_id}"
    }
    
    struct urlKeys {
        static var user_id = "id"
    }
}