//
//  ViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
// This is the view controller which represents the main hub where the user can see all locations of their memories
// and access them via the map. They can also be accessed in table view form in the other view controllers. 

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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
    }
    
    // Searches all of the user's specified locations from flights, memories, and events, and
    // stores them on the map. Nearby locations are stored in RAM with a singleton instance of
    // the NearbyLocations class, so no need to search for those. 
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
            let searchR = MKLocalSearch.Request()
            searchR.naturalLanguageQuery = "\(flight.nameOfFlyingFrom!) international airport"
            let search = MKLocalSearch(request: searchR)
            search.start {
                [weak self] (response, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                let places = response?.mapItems
                let place = places![0]
                let ani = MKPointAnnotation()
                ani.coordinate = place.placemark.coordinate
                ani.title = "Flight to \(flight.nameOfFlyingTo!), Date: \(flight.date!)"
                ani.subtitle = place.name
                let annotations = self?.map.annotations
                for m in annotations! {
                    if m.coordinate.latitude == ani.coordinate.latitude && m.coordinate.longitude == ani.coordinate.longitude {
                        let newLat = Double.random(in: -0.005...0.005)
                        let newLong = Double.random(in: -0.005...0.005)
                        ani.coordinate.longitude += newLong
                        ani.coordinate.latitude += newLat
                        break
                    }
                }
                self?.map.addAnnotation(ani)
            }
        }
        
        for event in events! {
            let searchR = MKLocalSearch.Request()
            searchR.naturalLanguageQuery = event.eventLocation
            let search = MKLocalSearch(request: searchR)
            search.start {
                [weak self] (response, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                let places = response?.mapItems
                let place = places![0]
                let ani = MKPointAnnotation()
                ani.coordinate = place.placemark.coordinate
                ani.title = "Event: \(event.eventName!), Date: \(event.eventDate!)"
                ani.subtitle = place.name
                let annotations = self?.map.annotations
                for m in annotations! {
                    if m.coordinate.latitude == ani.coordinate.latitude && m.coordinate.longitude == ani.coordinate.longitude {
                        let newLat = Double.random(in: -0.005...0.005)
                        let newLong = Double.random(in: -0.005...0.005)
                        ani.coordinate.longitude += newLong
                        ani.coordinate.latitude += newLat
                        break
                    }
                }
                self?.map.addAnnotation(ani)
            }
        }
        
        for memory in memories! {
            let searchR = MKLocalSearch.Request()
            searchR.naturalLanguageQuery = memory.location
            let search = MKLocalSearch(request: searchR)
            search.start {
                [weak self] (response, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                let places = response?.mapItems
                let place = places![0]
                let ani = MKPointAnnotation()
                ani.coordinate = place.placemark.coordinate
                ani.title = "Memory: \(memory.title!), Date: \(memory.dateTime!)"
                ani.subtitle = place.name
                let annotations = self?.map.annotations
                for m in annotations! {
                    if m.coordinate.latitude == ani.coordinate.latitude && m.coordinate.longitude == ani.coordinate.longitude {
                        let newLat = Double.random(in: -0.005...0.005)
                        let newLong = Double.random(in: -0.005...0.005)
                        ani.coordinate.longitude += newLong
                        ani.coordinate.latitude += newLat
                        break
                    }
                }
                self?.map.addAnnotation(ani)
            }
        }
        for loc in NearbyLocations.getInstance().locations {
            let ani = MKPointAnnotation()
            ani.coordinate = loc.placemark.coordinate
            ani.title = loc.name
            self.map.addAnnotation(ani)
        }
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
            if view.annotation?.title == "Flight to \(flight.nameOfFlyingTo!), Date: \(flight.date!)" {
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
            if view.annotation?.title == "Event: \(event.eventName!), Date: \(event.eventDate!)" {
                selectedEvent = event
                selectedIndex = index
                performSegue(withIdentifier: "eventDetail", sender: self)
                return
            }
        }
        let memories = MemoryModel()
        index = 0
        for memory in memories.getMemories()! {
            if view.annotation?.title == "Memory: \(memory.title!), Date: \(memory.dateTime!)" {
                selectedMemory = memory
                selectedIndex = index
                performSegue(withIdentifier: "memoryDetail", sender: self)
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
                viewController.toDest = true
            } else {
                viewController.destOrArrivalStr = "Arrival Flight"
                viewController.toDest = false
            }
            viewController.locationName = selectedFlight!.nameOfFlyingFrom
            viewController.durationStr = "Duration: \(selectedFlight!.duration!)"
            viewController.flightProviderStr = "Flight Provider: \(selectedFlight!.gate!)"
            viewController.locationToDestStr = "\(selectedFlight!.flyingFrom!)-\(selectedFlight!.flyingTo!)"
            viewController.timeOfFlightStr = "Time: \(selectedFlight!.flightTime!)"
            viewController.index = selectedIndex
            viewController.originalFlightProvider = selectedFlight!.gate!
            viewController.fromHome = true
            viewController.nameOfFlyingTo = selectedFlight!.nameOfFlyingTo
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

