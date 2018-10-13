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

class MemoryModel {
    // Contains all memories.
    var memories: [Memory]?
    
    func getMemories() -> [Memory]? {
        return memories
    }
}
