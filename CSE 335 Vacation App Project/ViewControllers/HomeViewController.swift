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

class HomeViewController: UIViewController, CLLocationManagerDelegate {

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
            if flight.toDest {
                geoCode(location: flight.nameOfFlyingTo!, name: "Flight to \(flight.nameOfFlyingFrom!)")
            } else {
                geoCode(location: flight.nameOfFlyingTo!, name: "Flight from \(flight.nameOfFlyingTo!)")
            }
        }
        
        for event in events! {
            geoCode(location: event.eventLocation!, name: event.eventName!)
        }
        
        for memory in memories! {
            geoCode(location: memory.location!, name: memory.title!)
        }
    }
    
    func geoCode(location: String, name: String) {
        CLGeocoder().geocodeAddressString(location, completionHandler: {(placemarks, error) in
            print("Geocoding location \(location)")
            if error != nil {
                print("Geocode failed: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let ani = MKPointAnnotation()
                ani.coordinate = placemark.location!.coordinate
                ani.title = name
                ani.subtitle = placemark.locality
                self.map.addAnnotation(ani)
            }
        })
    }
    
    func enableLocationServices() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    @IBAction func refreshLocation(_ sender: Any?) {
        print("hi i am refreshed")
        doLocationStuff()
    }
}

