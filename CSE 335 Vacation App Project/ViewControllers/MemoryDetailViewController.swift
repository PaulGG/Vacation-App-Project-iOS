//
//  MemoryDetailViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit
import MapKit

class MemoryDetailViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var map: MKMapView!
    
    var nameStr: String?
    var dateTimeStr: String?
    var locationStr: String?
    var pictureFile: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = nameStr
        dateTime.text = dateTimeStr
        location.text = locationStr
        picture.image = pictureFile
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController: EditMemoryViewController = segue.destination as? EditMemoryViewController {
            var dateTimeInfo = dateTimeStr?.split(separator: ",")
            dateTimeInfo![1] = dateTimeInfo![1].dropFirst()
            viewController.dateStr = String(dateTimeInfo![1])
            viewController.imageData = pictureFile
            viewController.locationStr = locationStr
            viewController.nameStr = nameStr
            viewController.timeStr = String(dateTimeInfo![0])
        }
    }
    

    @IBAction func memoryDetailUnwind(for unwindSegue: UIStoryboardSegue) {
        // TODO: semantics
    }

}
