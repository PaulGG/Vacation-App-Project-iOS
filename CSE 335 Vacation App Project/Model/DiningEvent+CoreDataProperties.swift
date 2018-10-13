//
//  DiningEvent+CoreDataProperties.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/13/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
//

import Foundation
import CoreData


extension DiningEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiningEvent> {
        return NSFetchRequest<DiningEvent>(entityName: "DiningEvent")
    }

    @NSManaged public var eventDate: String?
    @NSManaged public var eventName: String?
    @NSManaged public var eventTime: String?
    @NSManaged public var image: NSData?

}
