//
//  EventDetailViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController {

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
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
        doLocationStuff(location: locationStr!)
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
                doLocationStuff(location: originalLocationStr!)
            }
        }
    }
    
}
