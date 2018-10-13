//
//  Flight+CoreDataProperties.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/13/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
//

import Foundation
import CoreData


extension Flight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flight> {
        return NSFetchRequest<Flight>(entityName: "Flight")
    }

    @NSManaged public var arrival: Bool
    @NSManaged public var date: String?
    @NSManaged public var duration: String?
    @NSManaged public var flyingFrom: String?
    @NSManaged public var flyingTo: String?
    @NSManaged public var image: NSData?

}
