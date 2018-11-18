//
//  FlightDetailViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
// This is the view controller the user sees when they click on a flight in the specified tableview.
// It shows details of the flight to the user.

import UIKit
import MapKit

class FlightDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    // ====== IBOutlets ====== //
    
    @IBOutlet weak var destOrArrival: UILabel!
    @IBOutlet weak var locationToDest: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var flightProvider: UILabel!
    @IBOutlet weak var timeOfFlight: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    // MISC VARS
    var destOrArrivalStr: String?
    var locationToDestStr: String?
    var dateStr: String?
    var durationStr: String?
    var flightProviderStr: String?
    var timeOfFlightStr: String?
    var index: Int?
    var toDest: Bool?
    var fromHome = false
    var place: MKMapItem?
    var originalFlightProvider: String?
    var locationName: String?
    let locationManager = CLLocationManager()
    var nameOfFlyingTo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        destOrArrival.text = destOrArrivalStr
        locationToDest.text = locationToDestStr
        date.text = dateStr
        duration.text = durationStr
        flightProvider.text = flightProviderStr
        timeOfFlight.text = timeOfFlightStr
        locationManager.delegate = self
        map.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)            
        }
        doLocationStuff(location: "\(locationName!) international airport", name: "Flight to \(nameOfFlyingTo!)")
        // Do any additional setup after loading the view.
    }
    
    // Location method - is called when flight detail view is loaded to search for the
    // flight and display it on the map.
    func doLocationStuff(location: String, name: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = location
        let search = MKLocalSearch(request: request)
        search.start {
            [weak self] (response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            let places = (response?.mapItems)!
            self?.place = places[0]
            let place = places[0]
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: place.placemark.location!.coordinate, span: span)
            self?.map.setRegion(region, animated: true)
            let ani = MKPointAnnotation()
            ani.coordinate = place.placemark.coordinate
            ani.title = name
            ani.subtitle = place.name
            self?.map.addAnnotation(ani)
        }
    }
    
    @IBAction func flightDetailUnwind(for unwindSegue: UIStoryboardSegue) {
        if let viewController: EditFlightViewController = unwindSegue.source as? EditFlightViewController {
            if let flight = viewController.flightToUpdate {
                if flight.toDest {
                    destOrArrivalStr = "Arrival Flight"
                    locationName = flight.nameOfFlyingTo
                } else {
                    destOrArrivalStr = "Destination Flight"
                    locationName = flight.nameOfFlyingFrom
                }
                locationToDestStr = "\(flight.flyingFrom!)-\(flight.flyingTo!)"
                dateStr = "Date: \(flight.date!)"
                durationStr = flight.duration
                flightProviderStr = "Flight Provider: \(flight.gate!)"
                timeOfFlightStr = flight.flightTime
                viewDidLoad()
                doLocationStuff(location: "\(locationName!) international airport", name: "Flight to \(nameOfFlyingTo!)")
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController: EditFlightViewController = segue.destination as? EditFlightViewController {
            viewController.destOrArrivalStr = destOrArrivalStr
            viewController.locationToDestStr = locationToDestStr
            viewController.dateStr = dateStr
            viewController.flightProviderStr = flightProviderStr
            viewController.timeOfFlightStr = timeOfFlightStr
            viewController.index = index
            viewController.toDest = toDest
            // viewController.originalDuration = originalDuration
            viewController.originalFlightProvider = originalFlightProvider
        }
    }
    
    // This method ensures that if the user taps an annotation view, it will open in maps.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let flights = FlightModel()
        var index = 0
        for flight in flights.getFlights()! {
            if view.annotation?.title == "Flight to \(flight.nameOfFlyingTo!)" {
                self.index = index
                // segue to detail view
                place?.openInMaps(launchOptions: nil)
                return
            }
            index += 1
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        let view = MKMarkerAnnotationView()
        view.annotation = annotation
        view.markerTintColor = UIColor(red:0.22, green:0.66, blue:0.90, alpha:1.0)
        return view
    }
}
