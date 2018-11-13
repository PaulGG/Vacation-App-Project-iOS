//
//  PlannerViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // ====== IBOUTLETS ====== //
    
    @IBOutlet weak var flightTB: UITableView!
    @IBOutlet weak var eventTB: UITableView!
    @IBOutlet weak var flightEditBtn: UIBarButtonItem!
    @IBOutlet weak var eventEditBtn: UIBarButtonItem!
    
    // ====== MODELS ====== //
    
    let flightModel = FlightModel()
    let eventModel = EventModel()
    
    // ====== INITIALIZER METHODS ===== //
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*                                  /*
     ========= TABLEVIEW METHODS =========
     */                                  */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        if tableView == flightTB {
            cell = tableView.dequeueReusableCell(withIdentifier: "flightCell") as! FlightTableViewCell
            let flight = flightModel.get(at: indexPath.row)
            // TODO: add attributes from flight to cell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableViewCell
            let event = eventModel.get(at: indexPath.row)
            // TODO: add attributes from event to cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == flightTB {
            return flightModel.getCount()
        } else {
            return eventModel.getCount()
        }
    }
    
    // ====== DELETE CELL ======
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == flightTB {
            flightModel.delete(i: indexPath.row)
            flightTB.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            if flightModel.getCount() == 0 {
                flightEditBtn.title = "Edit"
            }
        } else {
            eventModel.delete(i: indexPath.row)
            eventTB.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            if eventModel.getCount() == 0 {
                eventEditBtn.title = "Edit"
            }
        }
    }
    
    // ====== UNWIND SEGUE METHOD ====== //
    
    @IBAction func plannerUnwind(for unwindSegue: UIStoryboardSegue) {
        // do nothing
    }
    
    /*                                  /*
     ========= IBACTION METHODS ==========
     */                                  */
    
    @IBAction func editFlights(_ sender: Any) {
        let bool = self.flightTB.isEditing
        if flightModel.getCount() != 0 {
            self.flightTB.setEditing(!bool, animated: true)
            if !bool {
                flightEditBtn.title = "Done"
                print("Done")
            } else {
                flightEditBtn.title = "Edit"
                print("Edit")
            }
        }
        
    }
    
    @IBAction func editEvents(_ sender: Any) {
        let bool = self.eventTB.isEditing
        if eventModel.getCount() != 0 {
            self.eventTB.setEditing(!bool, animated: true)
            if !bool {
                eventEditBtn.title = "Done"
                print("Done")
            } else {
                eventEditBtn.title = "Edit"
                print("Edit")
            }
        }
    }

    @IBAction func addEvent(_ sender: Any) {
        // TODO: Segue or UIAlertController?
    }
    
}
