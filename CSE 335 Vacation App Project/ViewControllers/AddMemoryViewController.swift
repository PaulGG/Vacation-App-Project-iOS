//
//  AddMemoryViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class AddMemoryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    // ====== IBOUTLETS ======
    
    @IBOutlet weak var imageSource: UISegmentedControl!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var image: UIImageView!
    
    // ====== MODEL ======
    
    let memoryModel = MemoryModel()
    
    // ====== MISC. OBJECTS ======
    
    let picker = UIImagePickerController()
    
    // ====== INITIALIZER METHODS ======
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
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
        present(picker, animated: true, completion: nil)
        imageSource.isSelected = false
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
        dismiss(animated: true, completion: nil)
    }
    
    /*                                  /*
     ========== IBACTION METHODS =========
     */                                  */
    
    @IBAction func done(_ sender: Any) {
        if name.text != nil && location.text != nil && image.image != nil {
            memoryModel.addMemory(dateTime: date.date.description, image: image.image!, location: location.text!, title: name.text!)
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
}
