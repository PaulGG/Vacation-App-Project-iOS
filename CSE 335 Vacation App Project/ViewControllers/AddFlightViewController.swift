//
//  AddFlightViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/9/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit
import SafariServices

class AddFlightViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    // ====== IBOUTLETS ======
    
    @IBOutlet weak var addFlightTableView: UITableView!
    @IBOutlet weak var failedLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // ====== MODEL ======
    
    var flightsToAdd = [FlightToBeConsidered]()
    
    // ====== MISC ======
    
    var rows : Int = 0

    // ====== INITIALIZER METHODS ======
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFlightTableView.delegate = self
        addFlightTableView.dataSource = self
    }
    
    /*                                  /*
     ========= TABLEVIEW METHODS =========
     */                                  */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addFlightCell") as! AddFlightTableViewCell
        let flight = flightsToAdd[indexPath.row]
        cell.returnDate.text = flight.returnDate
        cell.leaveDate.text = flight.leaveDate
        cell.origin.text = "From: \(flight.origin)"
        cell.destination.text = "To: \(flight.destination)"
        cell.price.text = "$\(String(flight.price))"
        cell.duration.text = "\(String(flight.duration)) mins"
        cell.gate.text = "Site: \(flight.gate)"
        print("This flight is: \(cell.returnDate.text), \(cell.leaveDate.text). \(cell.origin.text), \(cell.destination.text), \(cell.price.text), \(cell.duration.text), \(cell.gate.text)")
        return cell
    }
    
    /*                                  /*
     ============ JSON METHODS ===========
     */                                  */
    
    @IBAction func process() {
        failedLabel.isHidden = true
        let ipURLString = "https://www.travelpayouts.com/whereami?locale=en"
        let ipURL = URL(string: ipURLString)
        let urlSession = URLSession.shared
        
        // ====== FIND USER LOCATION =====
        
        let ipQuery = urlSession.dataTask(with: ipURL!, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            // Attempt to parse JSON data
            let jsonResult = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary)
            let location = jsonResult["iata"] as! NSString
            print("LOCATION: \(location)")
            
            // ======= FIND FLIGHTS ORIGINATING AT USER LOCATION =======
            
            DispatchQueue.main.async {
                if self.textField.text != nil && self.textField.text!.count >= 3 {
                    var dest = self.textField.text!
                    let index = dest.index(dest.startIndex, offsetBy: 3)
                    dest = String(dest[..<index])
                    let mainRequestURLString = "https://api.travelpayouts.com/v2/prices/latest?currency=usd&period_type=year&page=1&limit=30&show_to_affiliates=true&sorting=route&trip_class=0&token=97483c4d433a10e52d7b4ff5db302cb2&destination=\(dest)&origin=\(location)"
                    let mainReqURL = URL(string: mainRequestURLString)
                    let mainReqQuery = urlSession.dataTask(with: mainReqURL!, completionHandler: {data, response, error -> Void in
                        if (error != nil) {
                            print(error!.localizedDescription)
                        }
                        let newJsonRes = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary)
                        print("NEW FOO BAR: \(newJsonRes)")
                        // ===== PROCESS FLIGHTS =====
                        DispatchQueue.main.async {
                            if newJsonRes["message"] == nil && newJsonRes["errors"] == nil {
                                self.processFlights(jsonResults: newJsonRes)
                            } else {
                                self.failedLabel.isHidden = false
                            }
                        }
                    })
                    mainReqQuery.resume()
                } else {
                    self.failedLabel.isHidden = false
                }
            }
        })
        ipQuery.resume()
    }
    
    /*                                  /*
     ========== HELPER METHODS ===========
     */                                  */
    
    func processFlights(jsonResults: NSDictionary) {
        let data = jsonResults["data"] as! NSArray
        flightsToAdd = [FlightToBeConsidered]()
        var amount = 0
        for item in data {
            amount += 1
            let item = item as! NSDictionary
            let departDate = item["depart_date"] as! String
            let destination = item["destination"] as! String
            let gate = item["gate"] as! String
            // the starting place of the flight
            let origin = item["origin"] as! String
            // the return date of the flight
            let returnDate = item["return_date"] as! String
            // the price of the flight
            let price = item["value"] as! Double
            // how long the flight is
            let duration = item["duration"] as! Int
            let flightAdding = FlightToBeConsidered(returnDate: returnDate, leaveDate: departDate, origin: origin, destination: destination, price: price, duration: duration, gate: gate)
            flightsToAdd.append(flightAdding)
        }
        if amount > 0 {
            rows = data.count
            addFlightTableView.reloadData()
            print("i has reloaded datas")
        } else {
            failedLabel.isHidden = false
        }
        
    }
    
    /*                                  /*
     ========== SAFARI METHODS ===========
     */                                  */
    
    @IBAction func cityCodePage() {
        let urlString = "https://www.iata.org/publications/Pages/code-search.aspx"
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
    
    /*                                  /*
     ========== IBACTION METHODS =========
     */                                  */
    
    @IBAction func done(_ sender: Any) {
        // TODO: Add flight to model
        performSegue(withIdentifier: "unwindFlightAdd", sender: nil)
    }
    
    @IBAction func addCustom(_ sender: Any) {
        // TODO: Add UIAlertController for Custom
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
