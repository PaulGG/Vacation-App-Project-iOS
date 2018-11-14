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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = nameStr
        location.text = locationStr
        date.text = dateStr
        time.text = timeStr
        // TODO: FORWARD GEOCODE AND DISPLAY LOCATION ON MAP
    }
    
    @IBAction func eventDetailUnwind(for unwindSegue: UIStoryboardSegue) {
        // TODO: semantics
    }
    
}
