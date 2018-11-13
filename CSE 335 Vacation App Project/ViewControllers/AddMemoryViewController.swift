//
//  AddMemoryViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class AddMemoryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageSource: UISegmentedControl!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    
    let memoryModel = MemoryModel()
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

        // Do any additional setup after loading the view.
    }
    
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
    
    @IBAction func done(_ sender: Any) {
        if name.text != nil && location.text != nil && image.image != nil {
            memoryModel.addMemory(dateTime: date.date.description, image: image.image!, location: location.text!, title: name.text!)
            self.performSegue(withIdentifier: "bye", sender: self)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
