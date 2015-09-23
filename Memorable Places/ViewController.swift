//
//  ViewController.swift
//  Memorable Places
//
//  Created by Brad Gray on 7/18/15.
//  Copyright (c) 2015 Brad Gray. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!
    
    @IBOutlet weak var MapViewKit: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if activePlace == -1 {
            
           
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
         
        } else {
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["long"]!).doubleValue
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let latDelta: CLLocationDegrees = 0.01
            let lonDelta: CLLocationDegrees = 0.01
            let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            self.MapViewKit.setRegion(region, animated: true)
            let annontation = MKPointAnnotation()
            annontation.coordinate = coordinate
            annontation.title = places[activePlace]["name"]
            self.MapViewKit.addAnnotation(annontation)

        }
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 1.0
        MapViewKit.addGestureRecognizer(uilpgr)
    
    
    }
    
    func action(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
           
            let touchpoint = gestureRecognizer.locationInView(self.MapViewKit)
           
            let newCoordinate = self.MapViewKit.convertPoint(touchpoint, toCoordinateFromView: self.MapViewKit)
            
             let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                var title = ""
                
                if error == nil {
                    if let p = CLPlacemark? (placemarks![0]) {
                       
                        var subThoroughfare: String = ""
                       
                        var thoroughfare: String = ""
                            
                        if p.subThoroughfare != nil {
                            subThoroughfare = p.subThoroughfare!
                        }
                        
                        if p.thoroughfare != nil {
                            thoroughfare = p.thoroughfare!

                        }
                        title = "\(subThoroughfare) \(thoroughfare)"
                    }
                }
                if self.title == "" {
                    self.title = "Added \(NSDate())"
                }
                
                places.append(["name":title, "lat": "\(newCoordinate.latitude)", "long": "\(newCoordinate.latitude)"])
                
                var annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                
                annotation.title = title
                
                self.MapViewKit.addAnnotation(annotation)
                
            })
        }
    }
    
    
    
    
    
    
    
    
            
           
                
        
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocations: CLLocation = (locations[0] )
        let latitude = userLocations.coordinate.latitude
        let longitude = userLocations.coordinate.longitude
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let latDelta: CLLocationDegrees = 0.01
        let lonDelta: CLLocationDegrees = 0.01
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        self.MapViewKit.setRegion(region, animated: true)
    }
    
    
                
        
        



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


                }

