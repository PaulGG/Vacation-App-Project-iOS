//
//  CustomAddFlightViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
// This view controller exists so users can add their own custom flights.

import UIKit
import Foundation

class CustomAddFlightViewController: UIViewController, UITextFieldDelegate {
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    // ====== IBOutlets ====== //

    @IBOutlet weak var destOrArrival: UISegmentedControl!
    @IBOutlet weak var origin: UITextField!
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var provider: UITextField!
    @IBOutlet weak var departure: UIDatePicker!
    @IBOutlet weak var arrival: UIDatePicker!
    @IBOutlet weak var arrivalDate: UIDatePicker!
    
    // Misc Variable //
    
    var toDest: Bool?
    
    // ====== Model Variables ======/

    var flightModel = FlightModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        arrival.date = departure.date
        origin.delegate = self
        destination.delegate = self
        provider.delegate = self
    }
    
    // When a user is done adding a flight, this method is called. The logic for adding a flight is explained in detail in the ModelProcessor file.
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
                let hour : String
                if departureComponents.hour! < 10 {
                    hour = "0\(departureComponents.hour!)"
                } else {
                    hour = "\(departureComponents.hour!)"
                }
                let minute : String
                if departureComponents.minute! < 10 {
                    minute = "0\(departureComponents.minute!)"
                } else {
                    minute = "\(departureComponents.minute!)"
                }
                flightModel.addFlight(toDest: toDest!, date: "\(String(dateComponents.month!))/\(String(dateComponents.day!))/\(String(dateComponents.year!))", duration: Int(round(interval)), flyingFrom: origin.text!, flyingTo: destination.text!, gate: provider.text!, flightTime: "\(hour):\(minute)")
                performSegue(withIdentifier: "doneAddingCustomFlight", sender: self)
            } else {
                self.present(buildOKAlertButton(title: "You cannot have an arrival time that is earlier than your departure."), animated: true)
            }
        } else {
            self.present(buildOKAlertButton(title: "Please fill out all fields before continuing."), animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func buildOKAlertButton(title: String) -> UIAlertController {
        let t = title
        let alertController = UIAlertController(title: t, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alertController.addAction(okAction)
        return alertController
    }
}
