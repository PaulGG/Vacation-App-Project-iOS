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

class Flight: NSManagedObject {
    // Flight should have the following:
    // Flight image (default for all)
    // Departure or arrival bool
    // Location flying from
    // Location flying to
    // Duration of flight
    // Date of Flight
    @NSManaged public var image: UIImage?
    // This must be strictly 0 or 1. Objective C does not take Boolean types.
    @NSManaged public var arrival: NSNumber?
    @NSManaged public var flyingFrom: NSString?
    @NSManaged public var flyingTo: NSString?
    @NSManaged public var duration: NSString?
    @NSManaged public var date: NSString?
}

class Event: NSManagedObject {
    // Event should have the following:
    // Title of event
    // Time of Event
    // Date of Event
    var eventName: NSString?
    var eventTime: NSString?
    var eventDate: NSString?
    
}

protocol EventProtocol {
    // Subclasses must implement Image
    var image: UIImage? {get set}
}

class GenericEvent: Event, EventProtocol {
    var image: UIImage?
    // Should implement the following:
    // Image
}

class DiningEvent: Event, EventProtocol {
    var image: UIImage?
    // Should implement the following:
    // Image
}

class PlannerModel {
    // Contains all Events (and flights).
    var events: [Event]?
    var flights: [Flight]?
}
