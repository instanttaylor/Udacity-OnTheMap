//
//  Udacity.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/2/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

class Udacity: NSObject {
    
    var session: NSURLSession
    var sessionID: String? = nil
    var user = UdacityUser()
    let nc = NSNotificationCenter.defaultCenter()
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    func taskForPOSTMethod(method: String, jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Udacity.Constants.baseSecureURL + Udacity.Methods.session)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: NSJSONWritingOptions())
        }
        catch let error as NSError {
            print("Can't parse json: \(error)")
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in

            if let error = downloadError {
                completionHandler(result: nil, error: error)
            } else {
                if let data = data {
                    Udacity.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
                }
            }
        }
        
        task.resume()
        return task
    }
    
    func taskForDELETEMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: NSURL(string: Udacity.Constants.baseSecureURL + Udacity.Methods.session)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error)
                return
            } else {
                if let data = data {
                    Udacity.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
                }
            }
        }
        task.resume()
        return task
    }
    
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Udacity.Constants.baseSecureURL + method)!)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandler(result: nil, error: NSError(domain: "parse get", code: 1, userInfo: [NSLocalizedDescriptionKey: "bad call"]))
                return
            }
            
            guard let data = data else {
                completionHandler(result: nil, error: NSError(domain: "parse get", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data was returned"]))
                return
            }
            
            Udacity.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        task.resume()
        
        return task
    }
    
    class func parseJSONWithCompletionHandler(data: NSData , completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsed: AnyObject? = nil
        
        do {
            parsed = try NSJSONSerialization.JSONObjectWithData(data.subdataWithRange(NSMakeRange(5, data.length - 5)), options: .AllowFragments)
        }
        catch let error as NSError {
            completionHandler(result: nil, error: error)
        }
        completionHandler(result: parsed, error: nil)
    }
    
    class func sharedInstance() -> Udacity {
        
        struct Singleton {
            static var sharedInstance = Udacity()
        }
        
        return Singleton.sharedInstance
    }
}






