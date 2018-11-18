//
//  EditFlightViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
// This is the view controller the user sees when they edit a flight.

import UIKit

class EditFlightViewController: UIViewController, UITextFieldDelegate {
    
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
    
    // ====== Variables from segues ====== //
    
    var destOrArrivalStr: String?
    var locationToDestStr: String?
    var dateStr: String?
    var flightProviderStr: String?
    var timeOfFlightStr: String?
    var index: Int?
    var toDest: Bool?
    
    var originalFlightProvider: String?
    
    // ====== Model Variables ====== //
    
    var flightModel = FlightModel()
    var flightToUpdate : Flight?

    override func viewDidLoad() {
        super.viewDidLoad()
        origin.delegate = self
        destination.delegate = self
        provider.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        let locs = locationToDestStr?.split(separator: "-")
        let ori : String
        let dest: String
        if destOrArrivalStr == "Arrival Flight" {
            ori = String(locs![1])
            dest = String(locs![0])
        } else {
            ori = String(locs![0])
            dest = String(locs![1])
        }
        
        origin.text = ori
        destination.text = dest
        dateStr = String(dateStr!.dropFirst(6))
        let dateInfoStr = dateStr!.split(separator: "/")
        var dateInfo = [Int]()
        for i in dateInfoStr {
            dateInfo.append(Int(i)!)
        }
        let dateComponents = DateComponents.init(year: dateInfo[2], month: dateInfo[0], day: dateInfo[1])
        let cal = Calendar.current
        let dateCrafted = cal.date(from: dateComponents)
        date.date = dateCrafted!
        provider.text = originalFlightProvider
    }
    
    // Method is called on completion of flight editing. Similar method to the one in 'add flight' view controller. //
    @IBAction func done(_ sender: Any) {
        if origin.text != nil && destination.text != nil && provider.text != nil {
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
            //(round(durationTest) > 0 && round(timeInterval) >= 0) || (round(timeInterval) > 0)
            if interval > 0 {
                if destOrArrival.selectedSegmentIndex == 0 {
                    toDest = true
                } else {
                    toDest = false
                }
                flightModel.updateFlight(at: index!, toDest: toDest!, date: "\(String(dateComponents.month!))/\(String(dateComponents.day!))/\(String(dateComponents.year!))",  duration: Int(round(interval)), flyingFrom: origin.text!, flyingTo: destination.text!, gate: provider.text!)
                flightToUpdate = flightModel.get(at: index!)
                performSegue(withIdentifier: "doneEditingFlight", sender: nil)
            } else {
                self.present(buildOKAlertButton(title: "You cannot have an arrival time that is earlier than your departure."), animated: true)
            }
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
