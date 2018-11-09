//
//  AddFlightViewController.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/9/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import UIKit

class AddFlightViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                let mainRequestURLString = "https://api.travelpayouts.com/v2/prices/latest?currency=usd&period_type=year&page=1&limit=30&show_to_affiliates=true&sorting=route&trip_class=0&token=97483c4d433a10e52d7b4ff5db302cb2&destination=\(self.textField.text!)&origin=PHX"
                let mainReqURL = URL(string: mainRequestURLString)
                let mainReqQuery = urlSession.dataTask(with: mainReqURL!, completionHandler: {data, response, error -> Void in
                    if (error != nil) {
                        print(error!.localizedDescription)
                    }
                    let newJsonRes = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary)
                    print("NEW FOO BAR: \(newJsonRes)")
                })
                mainReqQuery.resume()
            }
        })
        ipQuery.resume()
        
        
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
