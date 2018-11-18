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
    
    // ====== Misc Variables ====== //
    var nameOfFlyingTo : String?
    var nameOfFlyingFrom : String?

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
            destOrArrival.selectedSegmentIndex = 1
            ori = String(locs![0])
            dest = String(locs![1])
        } else {
            destOrArrival.selectedSegmentIndex = 0
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
                
                // do web api processing here!
                var flyingTo = destination.text!
                var flyingFrom = origin.text!
                // Construct query that finds name 'flyingTo'
                // DispatchMainQueue:
                // Construct query that finds name 'flyingFrom'
                // DispatchMainQueue:
                // Add to flight model (nested)
                // If we don't need flyingTo:
                // Construct query that finds name 'flyingFrom'
                // DispatchMainQueue:
                // Add to flight model
                flyingTo = flyingTo.trimmingCharacters(in: .whitespaces)
                flyingFrom = flyingFrom.trimmingCharacters(in: .whitespaces)
                let toUrlString = "https://aviation-edge.com/v2/public/cities?key=17df8d-586cdb&code=\(flyingTo)"
                let fromUrlString = "https://aviation-edge.com/v2/public/cities?key=17df8d-586cdb&code=\(flyingFrom)"
                let toQuery = self.buildQuery(url: toUrlString, isDestination: true, toDest: self.toDest!, date: "\(String(dateComponents.month!))/\(String(dateComponents.day!))/\(String(dateComponents.year!))", duration: Int(round(interval)), flyingFrom: flyingFrom, flyingTo: flyingTo, gate: self.provider.text!, flightTime: "\(hour):\(minute)")
                if toQuery != nil {
                    toQuery!.resume()
                } else {
                    nameOfFlyingTo = flyingTo
                }
                let fromQuery = self.buildQuery(url: fromUrlString, isDestination: false, toDest: self.toDest!, date: "\(String(dateComponents.month!))/\(String(dateComponents.day!))/\(String(dateComponents.year!))", duration: Int(round(interval)), flyingFrom: flyingFrom, flyingTo: flyingTo, gate: self.provider.text!, flightTime: "\(hour):\(minute)")
                if fromQuery != nil {
                    fromQuery!.resume()
                } else {
                    nameOfFlyingFrom = flyingFrom
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        if toQuery!.state != .completed {
                            self.nameOfFlyingTo = flyingTo
                        }
                        self.flightModel.updateFlight(at: self.index!, toDest: self.toDest!, date: "\(String(dateComponents.month!))/\(String(dateComponents.day!))/\(String(dateComponents.year!))", duration: Int(round(interval)), flyingFrom: flyingFrom, flyingTo: flyingTo, gate: self.provider.text!, flightTime: "\(hour):\(minute)", nameOfFlyingTo: self.nameOfFlyingTo!, nameOfFlyingFrom: self.nameOfFlyingFrom!)
                        self.performSegue(withIdentifier: "doneEditingFlight", sender: self)
                    })
                }
            } else {
                self.present(buildOKAlertButton(title: "You cannot have an arrival time that is earlier than your departure."), animated: true)
            }
        } else {
            self.present(buildOKAlertButton(title: "Please fill out all fields before continuing."), animated: true)
        }
    }
    
    public func buildQuery(url: String, isDestination: Bool, toDest: Bool, date: String, duration: Int, flyingFrom: String, flyingTo : String, gate: String, flightTime: String) -> URLSessionDataTask? {
        let url = URL(string: url)
        let urlSession = URLSession.shared
        // If the URL is valid, proceed. If not (due to user input), return nil.
        if url != nil {
            let toQuery = urlSession.dataTask(with: url!, completionHandler: {data, response, error -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                }
                // If json result is valid, proceed.
                if let jsonResult = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSArray) {
                    let foo = jsonResult[0] as! NSDictionary
                    if let cityName = foo["name"] as? NSString {
                        // User input is valid. Proceed to use the data from the web api call.
                        DispatchQueue.main.async {
                            if isDestination {
                                self.nameOfFlyingTo = cityName as String
                            } else {
                                self.nameOfFlyingFrom = cityName as String
                                self.flightModel.updateFlight(at: self.index!, toDest: toDest, date: date, duration: duration, flyingFrom: flyingFrom, flyingTo: flyingTo, gate: gate, flightTime: flightTime, nameOfFlyingTo: self.nameOfFlyingTo!, nameOfFlyingFrom: self.nameOfFlyingFrom!)
                                self.flightToUpdate = self.flightModel.get(at: self.index!)
                                self.performSegue(withIdentifier: "doneEditingFlight", sender: self)
                            }
                        }
                    } else {
                        // Json result is not valid. Add normal user inputted values.
                        DispatchQueue.main.async {
                            if isDestination {
                                self.nameOfFlyingTo = flyingTo
                            } else {
                                self.nameOfFlyingFrom = flyingFrom
                                self.flightModel.updateFlight(at: self.index!, toDest: toDest, date: date, duration: duration, flyingFrom: flyingFrom, flyingTo: flyingTo, gate: gate, flightTime: flightTime, nameOfFlyingTo: self.nameOfFlyingTo!, nameOfFlyingFrom: self.nameOfFlyingFrom!)
                                self.flightToUpdate = self.flightModel.get(at: self.index!)
                                self.performSegue(withIdentifier: "doneEditingFlight", sender: self)
                            }
                        }
                    }
                } else {
                    // Json result is not valid. Add normal user inputted values.
                    DispatchQueue.main.async {
                        if isDestination {
                            self.nameOfFlyingTo = flyingTo
                        } else {
                            self.nameOfFlyingFrom = flyingFrom
                            self.flightModel.updateFlight(at: self.index!, toDest: toDest, date: date, duration: duration, flyingFrom: flyingFrom, flyingTo: flyingTo, gate: gate, flightTime: flightTime, nameOfFlyingTo: self.nameOfFlyingTo!, nameOfFlyingFrom: self.nameOfFlyingFrom!)
                            self.flightToUpdate = self.flightModel.get(at: self.index!)
                            self.performSegue(withIdentifier: "doneEditingFlight", sender: self)
                        }
                    }
                }
            })
            return toQuery
        } else {
            // URL is invalid, meaning the user inputted spaces or multiple words. we need to return nil.
            return nil
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
