//
//  AddEventViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/13/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {
    
    let eventModel = EventModel()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(_ sender: Any) {
        performSegue(withIdentifier: "unwindEventAdd", sender: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        if nameField.text != nil && locationField.text != nil {
            eventModel.addEvent(eventName: nameField.text!, eventDate: datePicker.date.description, eventTime: timePicker.date.description, eventLocation: locationField.text!)
            performSegue(withIdentifier: "unwindEventAdd", sender: nil)
        }
    }
}
