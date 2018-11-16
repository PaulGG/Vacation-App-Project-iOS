//
//  AddEventViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/13/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate {
    
    let eventModel = EventModel()
    
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
    
    @IBAction func cancel(_ sender: Any) {
        performSegue(withIdentifier: "unwindEventAdd", sender: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        if nameField.text != nil {
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
            eventModel.addEvent(eventName: nameField.text!, eventDate: "\(dateComponents.month!)/\(dateComponents.day!)/\(dateComponents.year!)", eventTime: "\(timeComponents.hour!):\(timeComponents.minute!)", eventLocation: locText)
            performSegue(withIdentifier: "unwindEventAdd", sender: nil)
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
}
