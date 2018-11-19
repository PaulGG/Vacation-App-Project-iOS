//
//  EventDetailViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
// This is the view controller the user sees when they click on an event in the specified tableview.
// It shows details of the event to the user.

import UIKit
import MapKit

class EventDetailViewController: UIViewController, MKMapViewDelegate {
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    // ====== IBOutlets ====== //

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    // MISC VARS
    
    var nameStr: String?
    var locationStr: String?
    var dateStr: String?
    var timeStr: String?
    var index: Int?
    var originalLocationStr: String?
    var place: MKMapItem?
    
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
    
    // Location method - is called when event detail view is loaded to search for the
    // event and display it on the map.
    
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
                nameStr = event.eventName
                originalLocationStr = event.eventLocation
                locationStr = "Location: \(event.eventLocation!)"
                dateStr = "Date: \(event.eventDate!)"
                timeStr = "Time: \(event.eventTime!)"
                viewDidLoad()
                doLocationStuff(location: originalLocationStr!, name: nameStr!)
            }
        }
    }
    
    // This method ensures that if the user taps an annotation view, it will open in maps.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let events = EventModel()
        var index = 0
        for event in events.getEvents()! {
            if view.annotation?.title == event.eventName! {
                self.index = index
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
        view.markerTintColor = UIColor(red:1.00, green:0.42, blue:0.80, alpha:1.0)
        return view
    }
}
