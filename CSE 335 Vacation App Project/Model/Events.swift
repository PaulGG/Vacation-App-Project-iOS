//
//  Events.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/13/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PlannerModel {
    // Contains all Events (and flights).
    var events: [Event]?
    var flights: [Flight]?
    
    func getAll() -> ([Event]?, [Flight]?) {
        return (events, flights)
    }
    
    func getEvents() -> [Event]? {
        return events
    }
    
    func getFlights() -> [Flight]? {
        return flights
    }
    
}

