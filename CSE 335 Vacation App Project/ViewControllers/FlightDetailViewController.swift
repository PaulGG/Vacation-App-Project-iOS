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
        // TODO: semantics
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
