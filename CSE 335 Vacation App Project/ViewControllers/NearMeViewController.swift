//
//  NearMeViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NearMeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    // ====== IBOUTLETS ======
    
    @IBOutlet weak var nearMeTableView: UITableView!
    
    // ====== MISC. OBJECTS ======

    var places =  [MKMapItem]()
    var locations = 0
    
    // ====== INITIALIZER METHODS ======
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNearbyLocations()
    }
    
    /*                                  /*
     ========== IBACTION METHODS =========
     */                                  */
    
    @IBAction func searchBy() {
        let alertController = UIAlertController(title: "Filter Results", message: "", preferredStyle: .alert)
        let inputAction = UIAlertAction(title: "Search", style: .default) { (action) in
            let text = alertController.textFields!.first!.text!
            if !text.isEmpty {
                self.present(self.buildOKAlertButton(title: "Filters Updated"), animated: true, completion: nil)
                NearbyLocations.getInstance().filter = text
                self.getNearbyLocations()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter topic to search for (i.e 'nearby')"
        }
        alertController.addAction(inputAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*                                  /*
     =========== HELPER METHODS ==========
     */                                  */
    
    private func getNearbyLocations() {
        let locationManager = CLLocationManager()
        let val = CLLocationManager.authorizationStatus()
        if val == .authorizedWhenInUse || val == .authorizedAlways  {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 100.0
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = NearbyLocations.getInstance().filter
        search(using: request)
    }
    
    private func search(using searchRequest: MKLocalSearch.Request) {
        
        // Use the network activity indicator as a hint to the user that a search is in progress.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.start {
            [weak self] (response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            self!.places = (response?.mapItems)!
            self!.locations = self!.places.count
            // TODO: might need to be fixed, force unwraps
            NearbyLocations.getInstance().locations = self!.places
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if self!.nearMeTableView != nil {
                self!.nearMeTableView.reloadData()
            }
        }
    }
    
    /*                                  /*
     ========= TABLEVIEW METHODS =========
     */                                  */
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        places[indexPath.row].openInMaps(launchOptions: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NearbyLocations.getInstance().filter!.capitalized
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nearMeTableView.dequeueReusableCell(withIdentifier: "nearMeCell") as! NearMeViewCell
        let loc = places[indexPath.row]
        cell.nearMe.text = loc.name!
        let coordinate_0 = CLLocation(latitude: loc.placemark.coordinate.latitude, longitude: loc.placemark.coordinate.longitude)
        let lm = CLLocationManager()
        let coordinate_1 = CLLocation(latitude: lm.location!.coordinate.latitude, longitude: lm.location!.coordinate.longitude)
        let distance = ((coordinate_0.distance(from: coordinate_1) / 1609) * 100.0).rounded() / 100.0
        cell.distance.text = "\(distance) miles"
        return cell
    }
    
    /*                                  /*
     ============ MISC METHODS ===========
     */                                  */
    
    func buildOKAlertButton(title: String) -> UIAlertController {
        let t = title
        let alertController = UIAlertController(title: t, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alertController.addAction(okAction)
        return alertController
    }
}
