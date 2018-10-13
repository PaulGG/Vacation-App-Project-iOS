//
//  Memories.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 10/13/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Memory: NSManagedObject {
    // Memory should have the following:
    // Image of Memory
    // Title of Memory
    // Date and time of memory
    // Location of memory
    @NSManaged public var image: UIImage?
    @NSManaged public var title: NSString?
    @NSManaged public var dateTime: NSString?
    @NSManaged public var location: NSString?
}

class MemoryModel {
    // Contains all memories.
    var memories: [Memory]?
}
