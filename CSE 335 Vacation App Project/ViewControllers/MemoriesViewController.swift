//
//  MemoriesViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class MemoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    // ====== IBOUTLETS ======

    @IBOutlet weak var memoryTableView: UITableView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    // ====== MODEL ======
    
    let memoryModel = MemoryModel()
    
    // ====== INITIALIZER METHODS =====
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /*                                  /*
     ========= TABLEVIEW METHODS =========
     */                                  */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoryModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    // ====== DELETE CELL ======
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        memoryModel.delete(i: indexPath.row)
        memoryTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        if memoryModel.getCount() == 0 {
            editBtn.title = "Edit"
        }
    }
    
    // ====== INITIALIZE CELL ======
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memoryTableView.dequeueReusableCell(withIdentifier: "memoryCell") as! MemoryViewCell
        let mem = memoryModel.get(at: indexPath.row)
        cell.dateTime.text = mem.dateTime
        cell.location.text = mem.location
        cell.name.text = mem.title
        let image = UIImage(data: mem.image!)
        print("Width: \(image!.size.width), Height: \(image!.size.height)")
        if mem.imageOrientation == UIImage.Orientation.right.rawValue && !cell.rotated {
            cell.rotated = true
            let temp = cell.pic.frame.size.width
            cell.pic.frame.size.width = cell.pic.frame.size.height
            cell.pic.frame.size.height = temp
            cell.pic.transform = cell.pic.transform.rotated(by: CGFloat(Double.pi / 2))
        }
        cell.pic.image = image
        
        return cell
    }
    
    // ====== PREPARE SEGUE ====== //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController: MemoryDetailViewController = segue.destination as? MemoryDetailViewController {
            let selectedIndex: IndexPath = memoryTableView.indexPath(for: sender as! UITableViewCell)!
            let memory = memoryModel.get(at: selectedIndex.row)
            viewController.dateTimeStr = memory.dateTime
            viewController.locationStr = memory.location
            viewController.nameStr = memory.title
            let cell = memoryTableView.cellForRow(at: selectedIndex) as! MemoryViewCell
            viewController.pictureFile = UIImage(data: memory.image!)
            viewController.index = selectedIndex.row
        } 
    }
    
    // ====== UNWIND SEGUE METHOD ======
    @IBAction func memoryUnwind(for unwindSegue: UIStoryboardSegue) {
        memoryModel.updateFetchResults()
        memoryTableView.reloadData()
    }
    
    /*                                  /*
     ========== IBACTION METHODS =========
     */                                  */
    
    @IBAction func edit(sender: UIBarButtonItem) {
        let bool = self.memoryTableView.isEditing
        if memoryModel.getCount() != 0 {
            self.memoryTableView.setEditing(!bool, animated: true)
            if !bool {
                editBtn.title = "Done"
                print("Done")
            } else {
                editBtn.title = "Edit"
                print("Edit")
            }
        }
    }
}
