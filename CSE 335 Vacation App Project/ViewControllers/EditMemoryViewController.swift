//
//  EditMemoryViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class EditMemoryViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var imageSource: UISegmentedControl!
    @IBOutlet weak var image: UIImageView!
    
    var nameStr: String?
    var locationStr: String?
    var dateStr: String?
    var timeStr: String?
    var imageData: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = nameStr
        location.text = locationStr
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
        date.date = dateCrafted!
        time.date = dateCrafted!
        image.image = imageData
        
        
        // Do any additional setup after loading the view.
    }
}
