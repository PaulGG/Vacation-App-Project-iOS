//
//  Memory+CoreDataProperties.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/13/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
//

import Foundation
import CoreData


extension Memory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memory> {
        return NSFetchRequest<Memory>(entityName: "Memory")
    }

    @NSManaged public var dateTime: String?
    @NSManaged public var image: NSData?
    @NSManaged public var location: String?
    @NSManaged public var title: String?

}
