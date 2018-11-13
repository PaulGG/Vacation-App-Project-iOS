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

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func enableLocationServices() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
}

