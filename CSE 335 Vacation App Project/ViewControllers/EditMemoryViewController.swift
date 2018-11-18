//
//  EditMemoryViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/14/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
// This is the view controller the user sees when they edit a memory.

import UIKit
import AVFoundation

class EditMemoryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    // ====== IBOutlets ====== //
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var imageSource: UISegmentedControl!
    @IBOutlet weak var image: UIImageView!
    
    // ======= Misc. Variables ====== //
    
    var nameStr: String?
    var locationStr: String?
    var dateStr: String?
    var timeStr: String?
    var imageData: UIImage?
    var index: Int?
    let picker = UIImagePickerController()
    
    // ====== Model Variables ====== //
    
    var memoryModel = MemoryModel()
    var memoryToUpdate: Memory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        location.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
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
    
    // Method that is called when the user attemps to take a photo with the camera or pick from photo library.
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
        // Self explanatory, if the user has authorized or has picked photo library, present it. Otherwise, notify
        // the user that they chosen to not authorize access.
        if cameraAuthStatus == .authorized || imageSource.selectedSegmentIndex == 1  || cameraAuthStatus == .notDetermined {
            present(picker, animated: true, completion: nil)
        } else {
            present(buildOKAlertButton(title: "You have specified to not allow camera usage in settings. Please select a photo from your library instead."), animated: true, completion: nil)
        }
    }
    
    /*                                  /*
    DELEGATE METHODS FOR PICKER CONTROLLER
     */                                  */
    
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
    
    /*                                  /*
     ========= IBACTION METHODS =========
     */                                  */
    
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
            memoryModel.updateMemory(at: index!, dateTime: "\(hour):\(minute), \(dateComponents.month!)/\(dateComponents.day!)/\(dateComponents.year!)", image: image.image!, location: location.text!, title: name.text!)
            memoryToUpdate = memoryModel.get(at: index!)
            performSegue(withIdentifier: "doneEditingMemory", sender: nil)
        }
    }
    
    /*                                  /*
     =========== MISC METHODS ============
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
