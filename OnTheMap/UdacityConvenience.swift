//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/12/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Udacity {
//    AUTHENTICATE
    func authWithUdacity(username: String, password: String, completionHandler: (success: Bool, error: NSError?) -> Void) {
//        Post session with username/pass
        nc.postNotificationName("showSpinner", object: nil)
        
        self.postSessionWithUserPass(username, password: password) { success, error in
            self.nc.postNotificationName("hideSpinner", object: nil)
            if success {
                self.getUser(self.user.user_id!) { success, error in
                    if success {
                        completionHandler(success: success, error: nil)
                    } else {
                        completionHandler(success: success, error: error)
                    }
                }
            } else {
                completionHandler(success: success, error: error)
            }
        }
    }
    
//    LOG IN
    func postSessionWithUserPass(username: String, password: String, completionHandler: (success: Bool, error: NSError?) -> Void) {
        let jsonBody = ["udacity":
                ["username":username, "password":password]
        ]
        
        nc.postNotificationName("showSpinner", object: nil)
        
        taskForPOSTMethod("POST", jsonBody: jsonBody) { result, error in
            self.nc.postNotificationName("hideSpinner", object: nil)
            if let error = error {
                completionHandler(success: false, error: error)
            } else {
                if let dictionary = result["account"] as? NSDictionary {
                    if let userKey = dictionary["key"] as? String {
                        self.user.user_id = userKey
                    }
                }
                
                if let dictionary = result["session"] as? NSDictionary {
                    if let session = dictionary["id"] as? String {
                        self.sessionID = session
                    }
                }
                
                if self.sessionID != nil && self.user.user_id != nil {
                    completionHandler(success: true, error: nil)
                } else {
                    completionHandler(success: false, error: NSError(domain: "session", code: 0, userInfo: [NSLocalizedDescriptionKey : "Incorrect cred"]))
                }
            }
        }
    }
    
    
//    LOG OUT
    
    func logout(completionHandler: (success: Bool, error: NSError?) -> Void) {
        nc.postNotificationName("showSpinner", object: nil)
        
        taskForDELETEMethod("DELETE") { (result, error) -> Void in
            self.nc.postNotificationName("hideSpinner", object: nil)
            if let error = error {
                completionHandler(success: false, error: error)
            } else {
                completionHandler(success: true, error: nil)
                self.sessionID = nil
            }
        }
    }
    
    
//    GET USER INFO
    
    func getUser(userKey: String, completionHandler: (success: Bool, error: NSError?) -> Void) {
        nc.postNotificationName("showSpinner", object: nil)
        taskForGETMethod("users/\(userKey)") { result, error in
            self.nc.postNotificationName("hideSpinner", object: nil)
            if let error = error {
                completionHandler(success: false, error: error)
            } else {
                if let userDictionary = result["user"] as? [String: AnyObject] {
                    self.user.firstName = userDictionary["first_name"] as? String
                    self.user.lastName = userDictionary["last_name"] as? String
                    completionHandler(success: true, error: nil)
                } else {
                    completionHandler(success: false, error: NSError(domain: "user", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"]))
                }
            }
        }
    }
    
}
