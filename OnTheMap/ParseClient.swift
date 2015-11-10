//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/19/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation

class ParseClient: NSObject {

    var session: NSURLSession

//    Set the data source
    var studentLocationDataSource = ParseStudentLocationDataSource()
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
//    make taskforgetmethod
    
    func taskForGETMethod(parameters: [String:AnyObject], queryString: String?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let query = (queryString != nil ? queryString : "")
        
        let urlStringComponents = NSURLComponents()
        urlStringComponents.scheme = "https"
        urlStringComponents.host = "api.parse.com"
        urlStringComponents.path = "/1/classes/StudentLocation"
        
        if parameters.count > 0 {
            urlStringComponents.queryItems = [NSURLQueryItem]()
            for (key, value) in parameters {
                urlStringComponents.queryItems?.append(NSURLQueryItem(name: key, value: "\(value)"))
            }
        } else {
            urlStringComponents.queryItems = nil
        }
        
        let url = NSURL(string: "\(urlStringComponents.string!)\(query!)")
        
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("PARSE: error on status code")
                completionHandler(result: nil, error: NSError(domain: "parse", code: 1, userInfo: [NSLocalizedDescriptionKey: "Parse status code error"]))
                return
            }
            
            guard let data = data else {
                print("PARSE: no data")
                completionHandler(result: nil, error: NSError(domain: "ParseClient.taskForGETMethod", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data was returned by the request!"]))
                return
            }
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        task.resume()
        
        return task
    }
    
//    make taskforpost
    func taskForPOSTMethod(parameters: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions())
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandler(result: nil, error: NSError(domain: "parse", code: 1, userInfo: [NSLocalizedDescriptionKey: "Parse post status code error"]))
                return
            }
            
            guard let data = data else {
                print("PARSE: no data")
                completionHandler(result: nil, error: NSError(domain: "parse", code: 1, userInfo: [NSLocalizedDescriptionKey: "Parse post data error"]))
                return
            }
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        task.resume()
        
        return task
    }
    
//    make put
    
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsed: AnyObject? = nil
        do {
            parsed = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        }
        catch let error as NSError {
            completionHandler(result: nil, error: error)
        }
        
        completionHandler(result: parsed, error: nil)
    }
    
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}