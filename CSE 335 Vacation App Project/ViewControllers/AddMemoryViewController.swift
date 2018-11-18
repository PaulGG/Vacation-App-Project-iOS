//
//  AddMemoryViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
// This is the view controller the user sees when they add a memory.

import UIKit
import AVFoundation

class AddMemoryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    // ====== IBOUTLETS ======
    
    @IBOutlet weak var imageSource: UISegmentedControl!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var image: UIImageView!
    
    // ====== MODEL ======
    
    let memoryModel = MemoryModel()
    
    // ====== MISC. OBJECTS ======
    
    let picker = UIImagePickerController()
    
    // ====== INITIALIZER METHODS ======
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        name.delegate = self
        location.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
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
        if cameraAuthStatus == .denied {
            present(buildOKAlertButton(title: "You have specified to not allow camera usage in settings. Please select a photo from your library instead."), animated: true, completion: nil)
        } else {
            present(picker, animated: true, completion: nil)
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
    
    /*                                  /*
     ========== IBACTION METHODS =========
     */                                  */
    
    @IBAction func done(_ sender: Any) {
        if name.text != nil && location.text != nil && image.image != nil {
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
            memoryModel.addMemory(dateTime: "\(dateComponents.month!)/\(dateComponents.day!)/\(dateComponents.year!), \(hour):\(minute)", image: image.image!, location: location.text!, title: name.text!)
            self.performSegue(withIdentifier: "bye", sender: self)
        } else {
            let alert = buildOKAlertButton(title: "Please fill out all forms.")
            self.present(alert, animated: true)
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
