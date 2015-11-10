//
//  ParseStudentLocation.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/19/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation

struct ParseStudentLocation {

    var objectId: String
    var latitude: Float
    var longitude: Float
    var mediaURL: String
    var firstName: String
    var lastName: String
    var mapString: String
    var uniqueKey: String

    var dictionary: NSDictionary {
        get {
            let d = NSMutableDictionary()
            d.setValue(self.objectId, forKey: "objectId")
            d.setValue(self.latitude, forKey: "latitude")
            d.setValue(self.longitude, forKey: "longitude")
            d.setValue(self.mediaURL, forKey: "mediaURL")
            d.setValue(self.firstName, forKey: "firstName")
            d.setValue(self.lastName, forKey: "lastName")
            d.setValue(self.mapString, forKey: "mapString")
            d.setValue(self.uniqueKey, forKey: "uniqueKey")
            return NSDictionary(dictionary: d)
        }
    }
    
    init(dict: NSDictionary) {
        objectId = dict.valueForKey("objectId") as! String! ?? "[No object id]"
        latitude = dict.valueForKey("latitude") as! Float? ?? 0.0
        longitude = dict.valueForKey("longitude") as! Float? ?? 0.0
        mediaURL = dict.valueForKey("mediaURL") as! String! ?? "[No media url]"
        firstName = dict.valueForKey("firstName") as! String! ?? "[No first name]"
        lastName = dict.valueForKey("lastName") as! String! ?? "[No last name]"
        mapString = dict.valueForKey("mapString") as! String! ?? "[No map string]"
        uniqueKey = dict.valueForKey("uniqueKey") as! String! ?? "[No unique key]"
    }
    


    static func createStudentLocations(dictionaries: [NSDictionary]) -> [ParseStudentLocation] {
        return dictionaries.map {ParseStudentLocation(dict: $0)}
    }
}