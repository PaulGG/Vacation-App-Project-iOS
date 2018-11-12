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
    
    @IBOutlet weak var addFlightTableView: UITableView!
 
    var flightsToAdd = [FlightToBeConsidered]()
    var rows : Int = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addFlightCell") as! AddFlightTableViewCell
        let flight = flightsToAdd[indexPath.row]
        cell.returnDate.text = flight.returnDate
        cell.leaveDate.text = flight.leaveDate
        cell.origin.text = flight.origin
        cell.destination.text = flight.destination
        cell.price.text = String(flight.price)
        cell.duration.text = String(flight.duration)
        cell.gate.text = flight.gate
        print("This flight is: \(cell.returnDate.text), \(cell.leaveDate.text). \(cell.origin.text), \(cell.destination.text), \(cell.price.text), \(cell.duration.text), \(cell.gate.text)")
        return cell
    }


    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFlightTableView.delegate = self
        addFlightTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func process() {
        // First get the user's location with one JSON request.
        
        // Next, get the flights and put them in table view.
        
        let ipURLString = "https://www.travelpayouts.com/whereami?locale=en"
        let ipURL = URL(string: ipURLString)
        let urlSession = URLSession.shared
        let ipQuery = urlSession.dataTask(with: ipURL!, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            // Attempt to parse JSON data
            let jsonResult = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary)
            let location = jsonResult["iata"] as! NSString
            print("LOCATION: \(location)")
            DispatchQueue.main.async {
                let mainRequestURLString = "https://api.travelpayouts.com/v2/prices/latest?currency=usd&period_type=year&page=1&limit=30&show_to_affiliates=true&sorting=route&trip_class=0&token=97483c4d433a10e52d7b4ff5db302cb2&destination=\(self.textField.text!)&origin=\(location)"
                let mainReqURL = URL(string: mainRequestURLString)
                let mainReqQuery = urlSession.dataTask(with: mainReqURL!, completionHandler: {data, response, error -> Void in
                    if (error != nil) {
                        print(error!.localizedDescription)
                    }
                    let newJsonRes = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary)
                    print("NEW FOO BAR: \(newJsonRes)")
                    DispatchQueue.main.async {
                        self.processFlights(jsonResults: newJsonRes)
                    }
                })
                mainReqQuery.resume()
            }
        })
        ipQuery.resume()
        
        
    }
    
    func processFlights(jsonResults: NSDictionary) {
        // Data currently in object:
        /*
         * arrival
         * date
         * duration
         * flyingFrom
         * flyingTo
         * image
         */
        let data = jsonResults["data"] as! NSArray
        flightsToAdd = [FlightToBeConsidered]()
        for item in data {
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
        rows = data.count
        addFlightTableView.reloadData()
        print("i has reloaded datas")
    }
    
    @IBAction func cityCodePage() {
        let urlString = "https://www.iata.org/publications/Pages/code-search.aspx"
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true, completion: nil)
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
