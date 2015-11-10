//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/19/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation

extension ParseClient {
    
//    get studentlocations
    
    func getStudentLocations(completionHandler: (result: [ParseStudentLocation]?, error: NSError?) -> Void) {
        
        let paramaters = ["limit":100,"order":"-updatedAt"]

        
        taskForGETMethod(paramaters, queryString: nil) { result, error in
            if error != nil {
                completionHandler(result: nil, error: error)
            } else {
                if let results = result.valueForKey("results") as? [NSDictionary] {
                    let studentLocations = ParseStudentLocation.createStudentLocations(results)
                    completionHandler(result: studentLocations, error: nil)
                } else {
                    completionHandler(result: nil, error: error)
                }
            }
        }
    }

    
//    get studentlocations with unique key
    
    
//    post student locations and check for errors
    func postStudentLocation(jsonBody: [String:AnyObject], completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        taskForPOSTMethod(jsonBody) { result, error in
            if let error = error {
                completionHandler(success: false, error: error)
            } else {
                if let _: AnyObject = result.valueForKey("createdAt") {
                    completionHandler(success: true, error: nil)
                } else {
                    print("error in post")
                    completionHandler(success: false, error: nil)
                }
            }
        }
        
        
    }
    
//    Put student location and check for errors
    
}