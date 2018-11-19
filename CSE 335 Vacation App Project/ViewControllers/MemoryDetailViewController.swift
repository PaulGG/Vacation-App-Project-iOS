//
//  MemoryDetailViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
// This is the view controller the user sees when they click on a memory in the specified tableview.
// It shows details of the memory to the user.

import UIKit
import MapKit

class MemoryDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    // ====== IBOUTLETS ======
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var map: MKMapView!
    
    // MISC VARS //
    
    var nameStr: String?
    var dateTimeStr: String?
    var locationStr: String?
    var pictureFile: UIImage?
    var index: Int?
    var rotate: Bool = false
    var place: MKMapItem?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = nameStr
        dateTime.text = dateTimeStr
        location.text = locationStr
        picture.image = pictureFile
        locationManager.delegate = self
        map.delegate = self
        if rotate {
            let temp = picture.frame.size.width
            picture.frame.size.width = picture.frame.size.height
            picture.frame.size.height = temp
            picture.transform = picture.transform.rotated(by: CGFloat(Double.pi / 2))
        }
        enableLocationServices()
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
        doLocationStuff(location: locationStr!, name: nameStr!)
    }
    
    func enableLocationServices() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    // Location method - is called when memory detail view is loaded to search for the
    // memory and display it on the map.
    func doLocationStuff(location: String, name: String) {
        map.removeAnnotations(map.annotations)
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
        if let viewController: EditMemoryViewController = segue.destination as? EditMemoryViewController {
            var dateTimeInfo = dateTimeStr?.split(separator: ",")
            dateTimeInfo![1] = dateTimeInfo![1].dropFirst()
            viewController.timeStr = String(dateTimeInfo![1])
            viewController.imageData = pictureFile
            viewController.locationStr = locationStr
            viewController.nameStr = nameStr
            viewController.dateStr = String(dateTimeInfo![0])
            viewController.index = index
        }
    }
    

    @IBAction func memoryDetailUnwind(for unwindSegue: UIStoryboardSegue) {
        if let viewController: EditMemoryViewController = unwindSegue.source as? EditMemoryViewController {
            if let memory = viewController.memoryToUpdate {
                name.text = memory.title
                dateTime.text = memory.dateTime
                location.text = memory.location
                picture.image = UIImage(data: memory.image!)
                doLocationStuff(location: location.text!, name: name.text!)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let memories = MemoryModel()
        var index = 0
        for memory in memories.getMemories()! {
            if view.annotation?.title == memory.title /*&& view.annotation?.subtitle == memory.location*/ {
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
        view.markerTintColor = UIColor(red:0.25, green:0.75, blue:0.50, alpha:1.0)
        return view
    }

}
