//
//  AddEventViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/13/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
// This is the view controller the user sees when they add an event.

import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate {
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    // ====== Model ====== //
    
    let eventModel = EventModel()
    
    // ====== IBOutlets ====== //
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        nameField.delegate = self
        locationField.delegate = self
    }
    
    /*                                  /*
     ========== IBACTION METHODS =========
     */                                  */
    
    // Method called if user chooses not to add an event by hitting the cancel button. //
    @IBAction func cancel(_ sender: Any) {
        performSegue(withIdentifier: "unwindEventAdd", sender: nil)
    }
    
    // Method called once user taps 'done' button, finished adding event. //
    @IBAction func done(_ sender: Any) {
        // Check for name field being empty. It's valid to leave the location empty if the user doesn't have one yet. //
        if nameField.text != nil {
            // Gets date components from date picker and turn them into string form. //
            let requestedDateComponents: Set<Calendar.Component> = [
                .year,
                .month,
                .day
            ]
            let requestedTimeComponents: Set<Calendar.Component> = [
                .hour,
                .minute
            ]
            let dateComponents = datePicker.calendar.dateComponents(requestedDateComponents, from: datePicker.date)
            let timeComponents = timePicker.calendar.dateComponents(requestedTimeComponents,from: timePicker.date)
            let locText:String
            if locationField.text == nil {
                locText = "Location Unknown"
            } else {
                locText = locationField.text!
            }
            let hour : String
            if timeComponents.hour! < 10 {
                hour = "0\(timeComponents.hour!)"
            } else {
                hour = "\(timeComponents.hour!)"
            }
            let minute : String
            if timeComponents.minute! < 10 {
                minute = "0\(timeComponents.minute!)"
            } else {
                minute = "\(timeComponents.minute!)"
            }
            // Add model with processed dates and information from user. //
            eventModel.addEvent(eventName: nameField.text!, eventDate: "\(dateComponents.month!)/\(dateComponents.day!)/\(dateComponents.year!)", eventTime: "\(hour):\(minute)", eventLocation: locText)
            // Unwind back to a detail view of the event. //
            performSegue(withIdentifier: "unwindEventAdd", sender: nil)
        }
    }
    
    /*                                  /*
     ========== KEYBOARD METHODS =========
     */                                  */
    
    // When the user hits the enter key, the keyboard goes down. //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // When the user taps anywhere on the screen, the keyboard goes away. //
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
