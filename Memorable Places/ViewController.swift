//
//  ViewController.swift
//  Memorable Places
//
//  Created by Brad Gray on 7/18/15.
//  Copyright (c) 2015 Brad Gray. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!
    
    @IBOutlet weak var MapViewKit: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy - kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 1.0
        MapViewKit.addGestureRecognizer(uilpgr)
        
        
    }
    func action(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            var touchPoint = gestureRecognizer.locationInView(self.MapViewKit)
            
            var newCoordinate = self.MapViewKit.convertPoint(touchPoint, toCoordinateFromView: self.MapViewKit)
            var location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
               var title = ""
                
                if error == nil {
                    if let p = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark) {
                        var subThoroughfare: String = ""
                        var thoroughfare: String = ""
                        
                        if p.subThoroughfare != nil {
                            subThoroughfare = p.subThoroughfare
                        }
                        if p.thoroughfare != nil {
                            thoroughfare = p.thoroughfare
                        }
                        title = "\(subThoroughfare) \(thoroughfare)"
                    }
                    
                }
                
                if title == "" {
                    title = "Added \(NSData())"
                }
                places.append(["name":title, "lat":"\(newCoordinate.latitude)", "long":"\(newCoordinate.longitude)"])
               
               
                var annontation = MKPointAnnotation()
                annontation.coordinate = newCoordinate
                annontation.title = title
                self.MapViewKit.addAnnotation(annontation)
                
                
            })
           
            
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocations: CLLocation = (locations[0] as! CLLocation)
        var latitude = userLocations.coordinate.latitude
        var longitude = userLocations.coordinate.longitude
        var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        var latDelta: CLLocationDegrees = 0.01
        var lonDelta: CLLocationDegrees = 0.01
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        self.MapViewKit.setRegion(region, animated: true)
    }
    
    
    
        
        



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

