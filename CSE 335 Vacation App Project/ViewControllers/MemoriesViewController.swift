//
//  MemoriesViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class MemoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var memoryTableView: UITableView!
    
    let memoryModel = MemoryModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoryModel.getCount()
    }
    
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
            cell.pic.transform = cell.pic.transform.rotated(by: CGFloat(M_PI_2))
        }
        cell.pic.image = image
        
        return cell
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        // do nothing
        memoryModel.updateFetchResults()
        memoryTableView.reloadData()
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