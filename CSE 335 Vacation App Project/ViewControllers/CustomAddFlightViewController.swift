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

    @IBOutlet weak var destOrArrival: UISegmentedControl!
    @IBOutlet weak var origin: UITextField!
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var provider: UITextField!
    @IBOutlet weak var departure: UIDatePicker!
    @IBOutlet weak var arrival: UIDatePicker!
    @IBOutlet weak var arrivalDate: UIDatePicker!
    
    var toDest: Bool?

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
            let arrivalDateComp = arrivalDate.calendar.dateComponents(requestedDateComponents, from: arrivalDate.date)
            let testOrigin = DateComponents.init(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: departureComponents.hour, minute: departureComponents.minute)
            let testArrival = DateComponents.init(year: arrivalDateComp.year, month: arrivalDateComp.month, day: arrivalDateComp.day, hour: arrivalComponents.hour, minute: arrivalComponents.minute)
            let cal = Calendar.current
            let originDate = cal.date(from: testOrigin)
            let newArrivalDate = cal.date(from: testArrival)
            let interval = newArrivalDate!.timeIntervalSince(originDate!) / 60
            if interval > 0 {
                if destOrArrival.selectedSegmentIndex == 0 {
                    toDest = true
                } else {
                    toDest = false
                }
                flightModel.addFlight(toDest: toDest!, date: "\(String(dateComponents.month!))/\(String(dateComponents.day!))/\(String(dateComponents.year!))", duration: Int(round(interval)), flyingFrom: origin.text!, flyingTo: destination.text!, gate: provider.text!)
                performSegue(withIdentifier: "doneAddingCustomFlight", sender: nil)
            } else {
                self.present(buildOKAlertButton(title: "You cannot have an arrival time that is earlier than your departure."), animated: true)
            }
        }
    }
    
    func buildOKAlertButton(title: String) -> UIAlertController {
        let t = title
        let alertController = UIAlertController(title: t, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alertController.addAction(okAction)
        return alertController
    }
}
