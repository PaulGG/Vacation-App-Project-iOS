//
//  FlightDetailViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit
import MapKit

class FlightDetailViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var destOrArrival: UILabel!
    @IBOutlet weak var locationToDest: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var flightProvider: UILabel!
    @IBOutlet weak var timeOfFlight: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    var destOrArrivalStr: String?
    var locationToDestStr: String?
    var dateStr: String?
    var durationStr: String?
    var flightProviderStr: String?
    var timeOfFlightStr: String?
    var index: Int?
    var toDest: Bool?
    
    var originalFlightProvider: String?
    var locationName: String?
    let locationManager = CLLocationManager()
    //var originalDuration: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        destOrArrival.text = destOrArrivalStr
        locationToDest.text = locationToDestStr
        date.text = dateStr
        duration.text = durationStr
        flightProvider.text = flightProviderStr
        timeOfFlight.text = timeOfFlightStr
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
        doLocationStuff(location: locationName!)
        // Do any additional setup after loading the view.
    }
    
    func doLocationStuff(location: String) {
        CLGeocoder().geocodeAddressString(location, completionHandler: {(placemarks, error) in
            if error != nil {
                print("Geocode failed: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                self.map.setRegion(region, animated: true)
                let ani = MKPointAnnotation()
                ani.coordinate = placemark.location!.coordinate
                ani.title = placemark.locality
                ani.subtitle = placemark.subLocality
                self.map.addAnnotation(ani)
            }
        })
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
                doLocationStuff(location: locationName!)
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
}
