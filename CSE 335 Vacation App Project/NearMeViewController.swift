//
//  NearMeViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class NearMeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nearMeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // TODO
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // TODO
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nearMeTableView.dequeueReusableCell(withIdentifier: "nearMeCell") as! NearMeViewCell
        //cell.label.text = "Hello There"
        print("i did this")
        return cell
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
