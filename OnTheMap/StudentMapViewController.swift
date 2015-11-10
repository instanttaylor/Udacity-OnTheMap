//
//  StudentMapViewController.swift
//  OnTheMap
//
//  Created by Taylor Smith on 10/19/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit
import MapKit

class StudentMapViewController: StudentLocationViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setMapPins()
    }
    
    func setMapPins() {
        let studentLocations = self.studentLocationDataSource?.studentLocations
        
        var placemarks = [MKPointAnnotation]()
        
        for loc in studentLocations! {
            let lat = CLLocationDegrees(loc.latitude)
            let long = CLLocationDegrees(loc.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinate
            annotation.title = "\(loc.firstName) \(loc.lastName)"
            annotation.subtitle = "\(loc.mediaURL)"
            
            placemarks.append(annotation)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.addAnnotations(placemarks)
        }
    }

}

extension StudentMapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin?.canShowCallout = true
            pin?.pinTintColor = UIColor.redColor()
            pin?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pin?.annotation = annotation
        }
        
        return pin!
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        var canOpen = false
        let app = UIApplication.sharedApplication()
        
        guard let _ = view.rightCalloutAccessoryView else {return}
        guard let annotation = view.annotation else {return}
        guard let canOpenURL = NSURL(string: annotation.subtitle!!) else {return}
        canOpen = app.canOpenURL(canOpenURL)
        
        if canOpen {
            app.openURL(canOpenURL)
        } else {
            let alertView = UIAlertController(title: "Ooops", message: "Bad link", preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
    }
}