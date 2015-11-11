//
//  StudentInputViewController.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/19/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class StudentInputViewController: UIViewController {

    let nc = NSNotificationCenter.defaultCenter()
    
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    var placemark: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextField.delegate = self
        addressTextField.delegate = self
        updateUIForSearch()
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        guard let text = linkTextField.text else {
            alertWithTitle("Ooops", message: "There's no text in the link field")
            return
        }
        submitLink(text)
    }
    
    func geocodeAddress(text: String) {
        nc.postNotificationName("showSpinner", object: nil)
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(text) { (results, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
            self.nc.postNotificationName("hideSpinner", object: nil)
            }
            if error != nil {
                self.alertWithTitle("Ooops", message: "Is that even an address?")
                return
            }
            
            if results!.isEmpty {
                self.alertWithTitle("Ooops", message: "We couldn't find that address")
            } else {
                self.placemark = results!.first
                self.mapView.showAnnotations([MKPlacemark(placemark: self.placemark)], animated: true)
                self.updateUIForLink()
            }
        }
    }
    
    func submitLink(text: String) {
        nc.postNotificationName("showSpinner", object: nil)
        guard let url = NSURL(string: text) else {
            return
        }
        
        if !UIApplication.sharedApplication().canOpenURL(url) {
            nc.postNotificationName("hideSpinner", object: nil)
            alertWithTitle("Ugh", message: "This url is bogus. Maybe add http://")
            return
        }
        
        let coord = self.placemark.location!.coordinate
        
        let jsonBody: [String: AnyObject] = [
            "uniqueKey":Udacity.sharedInstance().user.user_id!,
            "firstName":Udacity.sharedInstance().user.firstName!,
            "lastName":Udacity.sharedInstance().user.lastName!,
            "mapString":addressTextField.text!,
            "mediaURL":text,
            "latitude":coord.latitude,
            "longitude":coord.longitude,
        ]
        
        ParseClient.sharedInstance().postStudentLocation(jsonBody) { success, error in
            self.nc.postNotificationName("hideSpinner", object: nil)
            if error != nil {
                if let errorString = error?.userInfo["NSLocalizedDescription"]{
                    self.alertWithTitle("Ooops", message: errorString as! String)
                } else {
                    self.alertWithTitle("Ooops", message: "Failed to post location")
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    func updateUIForLink() {
        addressTextField.hidden = true
        linkTextField.hidden = false
        topText.text = "What link would you like to submit?"
        submitButton.hidden = false
    }
    
    func updateUIForSearch() {
        addressTextField.hidden = false
        linkTextField.hidden = true
        topText.text = "Where are you studying today?"
        submitButton.hidden = true
        addressTextField.becomeFirstResponder()
    }
    
    private func alertWithTitle(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        }
    }
}

extension StudentInputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("searching...")
        if textField.text! == "" {
            alertWithTitle("Ooops", message: "No text in the field.")
            return false
        }
        
        if textField.tag == 100 {
            geocodeAddress(textField.text!)
            textField.resignFirstResponder()
        } else if textField.tag == 101 {
            submitLink(textField.text!)
            textField.resignFirstResponder()
        }
        
        return false
    }
}
