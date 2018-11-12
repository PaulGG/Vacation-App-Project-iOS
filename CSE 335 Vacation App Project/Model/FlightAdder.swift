//
//  FlightAdder.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/12/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import Foundation

class FlightToBeConsidered {
    var returnDate: String
    var leaveDate: String
    var origin: String
    var destination: String
    var price: Double
    var duration: Int
    var gate: String
    
    init(returnDate: String, leaveDate: String, origin: String, destination: String, price: Double, duration: Int, gate: String) {
        self.returnDate = returnDate
        self.leaveDate = leaveDate
        self.origin = origin
        self.destination = destination
        self.price = price
        self.duration = duration
        self.gate = gate
    }
}

class FlightAdder {
    
}
