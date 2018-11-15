//
//  FlightDetailViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class FlightDetailViewController: UIViewController {
    
    @IBOutlet weak var destOrArrival: UILabel!
    @IBOutlet weak var locationToDest: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var flightProvider: UILabel!
    @IBOutlet weak var timeOfFlight: UILabel!
    
    var destOrArrivalStr: String?
    var locationToDestStr: String?
    var dateStr: String?
    var durationStr: String?
    var flightProviderStr: String?
    var timeOfFlightStr: String?
    var index: Int?
    var toDest: Bool?
    
    var originalFlightProvider: String?
    //var originalDuration: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        destOrArrival.text = destOrArrivalStr
        locationToDest.text = locationToDestStr
        date.text = dateStr
        duration.text = durationStr
        flightProvider.text = flightProviderStr
        timeOfFlight.text = timeOfFlightStr
        // Do any additional setup after loading the view.
    }
    
    @IBAction func flightDetailUnwind(for unwindSegue: UIStoryboardSegue) {
        if let viewController: EditFlightViewController = unwindSegue.source as? EditFlightViewController {
            if let flight = viewController.flightToUpdate {
                if flight.toDest {
                    destOrArrivalStr = "Arrival Flight"
                } else {
                    destOrArrivalStr = "Destination Flight"
                }
                locationToDestStr = "\(flight.flyingFrom!)-\(flight.flyingTo!)"
                dateStr = "Date: \(flight.date!)"
                durationStr = flight.duration
                flightProviderStr = "Flight Provider: \(flight.gate!)"
                timeOfFlightStr = flight.flightTime
                viewDidLoad()
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
