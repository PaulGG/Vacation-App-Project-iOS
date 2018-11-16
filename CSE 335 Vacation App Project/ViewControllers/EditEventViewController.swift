//
//  EditEventViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class EditEventViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var nameStr: String?
    var locationStr: String?
    var dateStr: String?
    var timeStr: String?
    var index: Int?
    
    var eventModel = EventModel()
    var eventToUpdate : Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = nameStr
        location.text = locationStr
        dateStr = String(dateStr!.dropFirst(6))
        timeStr = String(timeStr!.dropFirst(6))
        let dateInfoStr = dateStr!.split(separator: "/")
        let timeInfoStr = timeStr!.split(separator: ":")
        var dateInfo = [Int]()
        var timeInfo = [Int]()
        
        for i in dateInfoStr {
            dateInfo.append(Int(i)!)
        }
        for i in timeInfoStr {
            timeInfo.append(Int(i)!)
        }
        let dateComponents = DateComponents.init(year: dateInfo[2], month: dateInfo[0], day: dateInfo[1], hour: timeInfo[0], minute: timeInfo[1])
        let cal = Calendar.current
        let dateCrafted = cal.date(from: dateComponents)
        datePicker.date = dateCrafted!
        timePicker.date = dateCrafted!
        // Do any additional setup after loading the view.
    }
    
    @IBAction func done(_ sender: Any) {
        if name.text != nil {
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
            if location.text == nil {
                locText = "Location Unknown"
            } else {
                locText = location.text!
            }
            eventModel.updateEvent(at: index!, eventName: name.text!, eventDate: "\(dateComponents.month!)/\(dateComponents.day!)/\(dateComponents.year!)", eventTime: "\(timeComponents.hour!):\(timeComponents.minute!)", eventLocation: locText)
            eventToUpdate = eventModel.get(at: index!)
            performSegue(withIdentifier: "doneEditingEvent", sender: nil)
        }
    }
}