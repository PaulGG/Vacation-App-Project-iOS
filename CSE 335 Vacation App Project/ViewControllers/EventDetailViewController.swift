//
//  EventDetailViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    var nameStr: String?
    var locationStr: String?
    var dateStr: String?
    var timeStr: String?
    var index: Int?
    var originalLocationStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = nameStr
        location.text = locationStr
        date.text = dateStr
        time.text = timeStr
        map.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
        doLocationStuff(location: locationStr!, name: nameStr!)
    }
    
    func doLocationStuff(location: String, name: String) {
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
                ani.title = name
                ani.subtitle = location
                self.map.addAnnotation(ani)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController: EditEventViewController = segue.destination as? EditEventViewController {
            viewController.nameStr = nameStr
            viewController.locationStr = originalLocationStr
            viewController.dateStr = dateStr
            viewController.timeStr = timeStr
            viewController.index = index
        }
    }
    
    @IBAction func eventDetailUnwind(for unwindSegue: UIStoryboardSegue) {
        if let viewController : EditEventViewController = unwindSegue.source as? EditEventViewController {
            if let event = viewController.eventToUpdate {
                let event = viewController.eventToUpdate
                nameStr = event?.eventName
                originalLocationStr = event?.eventLocation
                locationStr = "Location: \(event!.eventLocation!)"
                dateStr = "Date: \(event!.eventDate!)"
                timeStr = "Time: \(event!.eventTime!)"
                viewDidLoad()
                doLocationStuff(location: originalLocationStr!, name: nameStr!)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        let view = MKMarkerAnnotationView()
        view.annotation = annotation
        view.markerTintColor = UIColor(red:1.00, green:0.42, blue:0.80, alpha:1.0)
        return view
    }
}
