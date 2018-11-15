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
        // TODO: FORWARD GEOCODE AND DISPLAY LOCATION ON MAP
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
                locationStr = "Location: \(event!.eventLocation!)"
                dateStr = "Date: \(event!.eventDate!)"
                timeStr = "Time: \(event!.eventTime!)"
                viewDidLoad()
            }
        }
    }
    
}
