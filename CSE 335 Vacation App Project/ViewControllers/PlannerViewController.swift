//
//  PlannerViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // ====== MODEL ======
    
    let eventModel = EventModel()
    
    // ====== INITIALIZER METHODS =====
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*                                  /*
     ========= TABLEVIEW METHODS =========
     */                                  */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: distinguish between the two different tableviews.
        let cell = tableView.dequeueReusableCell(withIdentifier: "flightCell") as! FlightTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: hardcoded
        return 5
    }
    
    // ====== UNWIND SEGUE METHOD ====== //
    
    @IBAction func plannerUnwind(for unwindSegue: UIStoryboardSegue) {
        // do nothing
    }
}
