//
//  MemoryDetailViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit
import MapKit

class MemoryDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var map: MKMapView!
    
    var nameStr: String?
    var dateTimeStr: String?
    var locationStr: String?
    var pictureFile: UIImage?
    var index: Int?
    var rotate: Bool = false

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
        if let viewController: EditMemoryViewController = segue.destination as? EditMemoryViewController {
            var dateTimeInfo = dateTimeStr?.split(separator: ",")
            dateTimeInfo![1] = dateTimeInfo![1].dropFirst()
            viewController.dateStr = String(dateTimeInfo![1])
            viewController.imageData = pictureFile
            viewController.locationStr = locationStr
            viewController.nameStr = nameStr
            viewController.timeStr = String(dateTimeInfo![0])
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
