//
//  EditMemoryViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit
import AVFoundation

class EditMemoryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    var index: Int?
    
    var memoryModel = MemoryModel()
    var memoryToUpdate: Memory?
    
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
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
    }
    
    /*                                  /*
     =========== IMAGE METHODS ===========
     */                                  */
    
    @IBAction func takePhoto(_ sender: Any) {
        if imageSource.selectedSegmentIndex == 0
        {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
            } else {
                print("No camera")
            }
            
        } else {
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            picker.modalPresentationStyle = .currentContext
        }
        let cameraMediaType = AVMediaType.video
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        imageSource.isSelected = false
        if cameraAuthStatus == .authorized || imageSource.selectedSegmentIndex == 1 {
            present(picker, animated: true, completion: nil)
        } else {
            present(buildOKAlertButton(title: "You have specified to not allow camera usage in settings. Please select a photo from your library instead."), animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        image.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if image.image?.imageOrientation == UIImage.Orientation.right {
            let temp = image.frame.size.width
            image.frame.size.width = image.frame.size.height
            image.frame.size.height = temp
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageSource.isSelected = false
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        if name.text != nil && location.text != nil {
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
            let timeComponents = time.calendar.dateComponents(requestedTimeComponents,from: time.date)
            memoryModel.updateMemory(at: index!, dateTime: "\(timeComponents.hour!):\(timeComponents.minute!), \(dateComponents.month!)/\(dateComponents.day!)/\(dateComponents.year!)", image: image.image!, location: location.text!, title: name.text!)
            memoryToUpdate = memoryModel.get(at: index!)
            performSegue(withIdentifier: "doneEditingMemory", sender: nil)
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
