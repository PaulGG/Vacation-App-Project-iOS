//
//  ViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    // ====== IBOUTLETS ======
    
    @IBOutlet weak var map: MKMapView!
    
    // ====== MISC. OBJECTS ======
    
    var locationManager = CLLocationManager()
    
    //let locationManager = CLLocationManager()
    
    // ====== INITIALIZER METHODS ======
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        doLocationStuff()
        locationManager.delegate = self
        map.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
    }
    
    func doLocationStuff() {
        // Get all models
        map.removeAnnotations(map.annotations)
        let flightModel = FlightModel()
        let eventModel = EventModel()
        let memoryModel = MemoryModel()
        
        let flights = flightModel.getFlights()
        let events = eventModel.getEvents()
        let memories = memoryModel.getMemories()
        
        for flight in flights! {
            geoCode(location: flight.nameOfFlyingTo!, name: "Flight to \(flight.nameOfFlyingFrom!)", object: flight)
        }
        
        for event in events! {
            geoCode(location: event.eventLocation!, name: event.eventName!, object: event)
        }
        
        for memory in memories! {
            geoCode(location: memory.location!, name: memory.title!, object: memory)
        }
    }
    
    func geoCode(location: String, name: String, object: AnyObject) {
        CLGeocoder().geocodeAddressString(location, completionHandler: {(placemarks, error) in
            if error != nil {
                print("Geocode failed: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let ani = MKPointAnnotation()
                ani.coordinate = placemark.location!.coordinate
                ani.title = name
                ani.subtitle = placemark.locality
                let annotations = self.map.annotations
                for ann in annotations {
                    // It is possible for map placemarks to be placed over each other.
                    // To avoid this scenario, we need to randomly generate placemark locations.
                    // It is still possible to have errors, but unlikely.
                    if ann.subtitle == ani.subtitle {
                        let newLat = Double.random(in: -0.05...0.05)
                        let newLong = Double.random(in: -0.05...0.05)
                        ani.coordinate.latitude += newLat
                        ani.coordinate.longitude += newLong
                        break
                    }
                }
                self.map.addAnnotation(ani)
                //self.map.addAnnotation(aniView as! MKAnnotation)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        let aniView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        return aniView
    }
    
    func enableLocationServices() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    @IBAction func refreshLocation(_ sender: Any?) {
        doLocationStuff()
    }
}

