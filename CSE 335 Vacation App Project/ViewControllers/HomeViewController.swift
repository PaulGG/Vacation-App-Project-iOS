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
    var selectedFlight: Flight?
    var selectedEvent: Event?
    var selectedMemory: Memory?
    var selectedIndex: Int?
    var loaded = false
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        if !loaded {
            loaded = true
        } else {
            doLocationStuff()
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
            print("Heres a flight")
            geoCode(location: "\(flight.nameOfFlyingTo!) international airport", name: "Flight to \(flight.nameOfFlyingFrom!), \(flight.date!)")
        }
        
        for event in events! {
            print("Heres an event")
            geoCode(location: event.eventLocation!, name: "Event: \(event.eventName!)")
        }
        
        for memory in memories! {
            print("Heres a memory")
            geoCode(location: memory.location!, name: "Memory: \(memory.title!)")
        }
        for loc in NearbyLocations.getInstance().locations {
            let ani = MKPointAnnotation()
            ani.coordinate = loc.placemark.coordinate
            ani.title = loc.name
            map.addAnnotation(ani)
        }
    }
    
    func geoCode(location: String, name: String) {
        CLGeocoder().geocodeAddressString(location, completionHandler: {(placemarks, error) in
            if error != nil {
                print("Geocode failed: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let ani = MKPointAnnotation()
                ani.coordinate = placemark.location!.coordinate
                ani.title = name
                ani.subtitle = location
                let annotations = self.map.annotations
                for ann in annotations {
                    // It is possible for map placemarks to be placed over each other.
                    // To avoid this scenario, we need to randomly generate placemark locations.
                    // It is still possible to have errors, but unlikely.
                    if ann.subtitle == ani.subtitle {
                        let newLat = Double.random(in: -0.001...0.001)
                        let newLong = Double.random(in: -0.001...0.001)
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
        let t = aniView.annotation!.title!!
        if t.range(of: "Event") != nil {
            aniView.markerTintColor = UIColor(red:1.00, green:0.42, blue:0.80, alpha:1.0)
        } else if t.range(of: "Flight") != nil {
            aniView.markerTintColor = UIColor(red:0.22, green:0.66, blue:0.90, alpha:1.0)
        } else if t.range(of: "Memory") != nil {
            aniView.markerTintColor = UIColor(red:0.25, green:0.75, blue:0.50, alpha:1.0)
        }
        return aniView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for loc in NearbyLocations.getInstance().locations {
            if view.annotation?.coordinate.latitude == loc.placemark.coordinate.latitude  && view.annotation?.coordinate.longitude == loc.placemark.coordinate.longitude {
                loc.openInMaps(launchOptions: nil)
                return
            }
        }
        let flights = FlightModel()
        var index = 0
        for flight in flights.getFlights()! {
            if view.annotation?.title == "Flight to \(flight.nameOfFlyingFrom!), \(flight.date!)" {
                selectedFlight = flight
                selectedIndex = index
                // segue to detail view
                performSegue(withIdentifier: "flightDetail", sender: self)
                return
            }
            index += 1
        }
        let events = EventModel()
        index = 0
        for event in events.getEvents()! {
            if view.annotation?.title == "Event: \(event.eventName!)" && view.annotation?.subtitle == event.eventLocation {
                selectedEvent = event
                selectedIndex = index
                performSegue(withIdentifier: "eventDetail", sender: self)
                print("segue performed")
                return
            }
        }
        let memories = MemoryModel()
        index = 0
        for memory in memories.getMemories()! {
            if view.annotation?.title == "Memory: \(memory.title!)" && view.annotation?.subtitle == memory.location {
                selectedMemory = memory
                selectedIndex = index
                performSegue(withIdentifier: "memoryDetail", sender: self)
                print("segue performed")
                return
            }
        }
    }
    
    @IBAction func unwindToHome(for unwindSegue: UIStoryboardSegue) {
        doLocationStuff()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? FlightDetailViewController {
            viewController.dateStr = "Date: \(selectedFlight!.date!)"
            if selectedFlight!.toDest {
                viewController.destOrArrivalStr = "Departure Flight"
                viewController.locationName = selectedFlight!.nameOfFlyingTo
                viewController.toDest = true
            } else {
                viewController.destOrArrivalStr = "Arrival Flight"
                viewController.locationName = selectedFlight!.nameOfFlyingTo
                viewController.toDest = false
            }
            viewController.durationStr = "Duration: \(selectedFlight!.duration!)"
            viewController.flightProviderStr = "Flight Provider: \(selectedFlight!.gate!)"
            viewController.locationToDestStr = "\(selectedFlight!.flyingFrom!)-\(selectedFlight!.flyingTo!)"
            viewController.timeOfFlightStr = "Time: \(selectedFlight!.flightTime!)"
            viewController.index = selectedIndex
            viewController.originalFlightProvider = selectedFlight!.gate!
            viewController.fromHome = true
        } else if let viewController = segue.destination as? EventDetailViewController {
            viewController.dateStr = "Date: \(selectedEvent!.eventDate!)"
            viewController.locationStr = "Location: \(selectedEvent!.eventLocation!)"
            viewController.nameStr = selectedEvent!.eventName
            viewController.timeStr = "Time: \(selectedEvent!.eventTime!)"
            viewController.index = selectedIndex
            viewController.originalLocationStr = selectedEvent!.eventLocation
        } else if let viewController = segue.destination as? MemoryDetailViewController {
            viewController.dateTimeStr = selectedMemory!.dateTime
            viewController.locationStr = selectedMemory!.location
            viewController.nameStr = selectedMemory!.title
            viewController.pictureFile = UIImage(data: selectedMemory!.image!)
            viewController.index = selectedIndex
            if selectedMemory!.imageOrientation == UIImage.Orientation.right.rawValue {
                viewController.rotate = true
            }
        }
    }
    
    func enableLocationServices() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    @IBAction func refreshLocation(_ sender: Any?) {
        doLocationStuff()
    }
    
    @IBAction func switched(_ sender: UISwitch) {
        doLocationStuff()
    }
}

