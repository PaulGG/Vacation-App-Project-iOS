//
//  CustomAddFlightViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit
import Foundation

class CustomAddFlightViewController: UIViewController {

    // todo
    @IBOutlet weak var destOrArrival: UIPickerView!
    
    @IBOutlet weak var origin: UITextField!
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var provider: UITextField!
    @IBOutlet weak var departure: UIDatePicker!
    @IBOutlet weak var arrival: UIDatePicker!

    var flightModel = FlightModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrival.date = departure.date
    }
    
    @IBAction func done(_ sender: Any) {
        if !(origin.text?.isEmpty)! && !(destination.text?.isEmpty)! && !(provider.text?.isEmpty)! /*&& duration.text != nil*/ {
            let requestedDateComponents: Set<Calendar.Component> = [
                .year,
                .month,
                .day
            ]
            let requestedTimeComponents: Set<Calendar.Component> = [
                .hour,
                .minute
            ]
            let dateComponents = date.calendar.dateComponents(requestedDateComponents, from: date.date)
            let departureComponents = departure.calendar.dateComponents(requestedTimeComponents,from: departure.date)
            let arrivalComponents = arrival.calendar.dateComponents(requestedTimeComponents,from: arrival.date)
            let durationTest = arrival.date.timeIntervalSince(departure.date) / 60
            print(durationTest)
            
            flightModel.addFlight(toDest: true, date: "\(String(dateComponents.month!))/\(String(dateComponents.day!))/\(String(dateComponents.year!))", duration: Int(round(durationTest)), flyingFrom: origin.text!, flyingTo: destination.text!, gate: provider.text!)
            performSegue(withIdentifier: "doneAddingCustomFlight", sender: nil)
        }
    }

}
