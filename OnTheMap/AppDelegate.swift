//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/2/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit
import SwiftSpinner

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "showSpinner", name: "showSpinner", object: nil)
        center.addObserver(self, selector: "hideSpinner", name: "hideSpinner", object: nil)
        
        return true
    }

    func showSpinner() {
        dispatch_async(dispatch_get_main_queue()) {
            SwiftSpinner.show("Working...").addTapHandler({
                SwiftSpinner.hide()
                }, subtitle: "Tap to hide while connecting! This will affect only the current operation.")
        }
    }
    
    func hideSpinner() {
        dispatch_async(dispatch_get_main_queue()) {
            SwiftSpinner.hide()
        }
    }
}

