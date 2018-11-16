//
//  ModelProcessor.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/9/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/*                                  /*
 === FLIGHT TO BE CONSIDERED CLASS ===
 Class that is used for handling JSON
 objects.
 */                                  */

class FlightToBeConsidered {
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    var returnDate: String
    var leaveDate: String
    var origin: String
    var destination: String
    var price: Double
    var duration: Int
    var gate: String
    
    /*                                  /*
     ============ CONSTRUCTOR ============
     */                                  */
    
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

/*                                  /*
 =========== PARENT MODEL ============
 Parent class for all models.
 */                                  */

class GenericModelContainer {
    let managedObjectContext: NSManagedObjectContext
    var ent: NSEntityDescription?
    
    /*                                  /*
     ============= VARIABLES =============
     */                                  */
    
    /*                                  /*
     ============ CONSTRUCTOR ============
     */                                  */
    
    init() {
        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}

/*                                  /*
 =========== MEMORY MODEL ============
 Contains all memories.
 */                                  */

class MemoryModel : GenericModelContainer {
    
    // ====== VARIABLE ====== //

    var fetchResults: [Memory]?
    
    // ====== CONSTRUCTOR ====== //
    
    override init() {
        super.init()
        self.ent = NSEntityDescription.entity(forEntityName: "Memory", in: self.managedObjectContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memory")
        self.fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [Memory])!
    }
    
    /*                                  /*
     ========== GET/SET/DELETE ===========
     */                                  */
    
    // ====== GET ====== //
    
    public func getMemories() -> [Memory]? {
        return fetchResults
    }
    
    public func getCount() -> Int {
        return fetchResults!.count
    }
    
    public func get(at: Int) -> Memory {
        return fetchResults![at]
    }
    
    // ====== SET ====== //
    
    public func updateMemory(at: Int, dateTime: String, image: UIImage, location: String, title: String) {
        let update = fetchResults![at]
        update.dateTime = dateTime
        update.location = location
        update.title = title
        update.image = image.pngData()
        update.imageOrientation = Int32(image.imageOrientation.rawValue)
        save()
    }
    
    public func addMemory(dateTime: String, image: UIImage, location: String, title: String) {
        let memoryAdding = Memory(entity: ent!, insertInto: managedObjectContext)
        memoryAdding.dateTime = dateTime
        memoryAdding.location = location
        memoryAdding.title = title
        memoryAdding.image = image.pngData()
        memoryAdding.imageOrientation = Int32(image.imageOrientation.rawValue)
        save()
    }
    
    public func updateFetchResults() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memory")
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [Memory])
    }
    
    public func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Exception")
        }
        updateFetchResults()
    }

    // ====== DELETE ====== //
    
    public func delete(i: Int) {
        managedObjectContext.delete(self.fetchResults![i])
        save()
    }
}

class FlightModel : GenericModelContainer {
    
    // ====== VARIABLE ====== //
    
    var fetchResults: [Flight]?
    
    // ====== CONSTRUCTOR ====== //
    
    override init() {
        super.init()
        self.ent = NSEntityDescription.entity(forEntityName: "Flight", in: self.managedObjectContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Flight")
        self.fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [Flight])!
    }
    
    /*                                  /*
     ========== GET/SET/DELETE ===========
     */                                  */
    
    // ====== GET ====== //
    
    func getFlights() -> [Flight]? {
        return fetchResults
    }
    
    public func getCount() -> Int {
        return fetchResults!.count
    }
    
    public func get(at: Int) -> Flight {
        return fetchResults![at]
    }
    
    // ====== SET ====== //
    
    public func updateFetchResults() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Flight")
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [Flight])
    }
    
    public func addFlight(toDest: Bool, date: String, duration: Int, flyingFrom: String, flyingTo: String, gate: String) {
        let flightAdding = Flight(entity: ent!, insertInto: managedObjectContext)
        flightAdding.toDest = toDest
        flightAdding.date = date
        let hours: Int = duration / 60
        if hours == 0 {
            flightAdding.duration = "\(duration) mins"
        } else {
            flightAdding.duration = "\(hours) hrs, \(duration % 60) mins"
        }

        flightAdding.flyingFrom = flyingFrom
        flightAdding.flyingTo = flyingTo
        flightAdding.image = UIImage(named: "flightPicture.png")?.pngData()
        flightAdding.gate = gate
        flightAdding.flightTime = "Please enter manually."
        // json call
        // Call 1 //
        let toQuery = buildQuery(string: "https://aviation-edge.com/v2/public/cities?key=17df8d-586cdb&code=\(flightAdding.flyingTo!)", arrival: false, object: flightAdding)
        toQuery.resume()
        // Call 2 //
        let fromQuery = buildQuery(string: "https://aviation-edge.com/v2/public/cities?key=17df8d-586cdb&code=\(flightAdding.flyingFrom!)", arrival: true, object: flightAdding)
        fromQuery.resume()
        save()
    }
    
    public func updateFlight(at: Int, toDest: Bool, date: String, duration: Int, flyingFrom: String, flyingTo: String, gate: String) {
        let update = fetchResults![at]
        update.toDest = toDest
        update.date = date
        let hours: Int = duration / 60
        if hours == 0 {
            update.duration = "\(duration) mins"
        } else {
            update.duration = "\(hours) hrs, \(duration % 60) mins"
        }
        update.flyingFrom = flyingFrom
        update.flyingTo = flyingTo
        update.image = UIImage(named: "flightPicture")?.pngData()
        update.gate = gate
        // json call
        // Call 1 //
        let toQuery = buildQuery(string: "https://aviation-edge.com/v2/public/cities?key=17df8d-586cdb&code=\(update.flyingTo!)", arrival: false, object: update)
        toQuery.resume()
        // Call 2 //
        let fromQuery = buildQuery(string: "https://aviation-edge.com/v2/public/cities?key=17df8d-586cdb&code=\(update.flyingFrom!)", arrival: true, object: update)
        fromQuery.resume()
        save()
    }
    
    public func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Exception")
        }
        updateFetchResults()
    }
    
    // ====== DELETE ====== //
    
    public func delete(i: Int) {
        managedObjectContext.delete(self.fetchResults![i])
        save()
    }
    
    public func buildQuery(string: String, arrival: Bool, object: Flight) -> URLSessionDataTask {
        let url = URL(string: string)
        let urlSession = URLSession.shared
        let toQuery = urlSession.dataTask(with: url!, completionHandler: {data, response, error -> Void in
            if error != nil {
                print(error!.localizedDescription)
            }
            if let jsonResult = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSArray) {
                let foo = jsonResult[0] as! NSDictionary
                if let cityName = foo["name"] as? NSString {
                    DispatchQueue.main.async {
                        if arrival {
                            object.nameOfFlyingTo = cityName as String
                        } else {
                            object.nameOfFlyingFrom = cityName as String
                        }
                        self.save()
                    }
                } else {
                    DispatchQueue.main.async {
                        if arrival {
                            object.nameOfFlyingTo = object.flyingTo
                        } else {
                            object.nameOfFlyingFrom = object.flyingFrom
                        }
                        self.save()
                    }
                } 
            } else {
                DispatchQueue.main.async {
                    if arrival {
                        object.nameOfFlyingTo = object.flyingTo
                    } else {
                        object.nameOfFlyingFrom = object.flyingFrom
                    }
                    self.save()
                }
            }
        })
        return toQuery
    }
}

class EventModel : GenericModelContainer {
    
    // ====== VARIABLE ====== //
    
    var fetchResults: [Event]?
    
    // ====== CONSTRUCTOR ====== //
    
    override init() {
        super.init()
        self.ent = NSEntityDescription.entity(forEntityName: "Event", in: self.managedObjectContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        self.fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [Event])!
    }
    
    /*                                  /*
     ========== GET/SET/DELETE ===========
     */                                  */
    
    // ====== GET ====== //
    
    func getEvents() -> [Event]? {
        return fetchResults
    }
    
    public func getCount() -> Int {
        return fetchResults!.count
    }
    
    public func get(at: Int) -> Event {
        return fetchResults![at]
    }
    
    // ====== SET ====== //
    
    public func updateFetchResults() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [Event])
    }
    
    public func addEvent(eventName: String, eventDate: String, eventTime: String, eventLocation: String) {
        let eventAdding = Event(entity: ent!, insertInto: managedObjectContext)
        eventAdding.eventName = eventName
        eventAdding.eventDate = eventDate
        eventAdding.eventTime = eventTime
        eventAdding.eventLocation = eventLocation
        eventAdding.image = UIImage(named: "eventPicture.jpg")?.jpegData(compressionQuality: 30)
        save()
    }
    
    public func updateEvent(at: Int, eventName: String, eventDate: String, eventTime: String, eventLocation: String) {
        let update = fetchResults![at]
        update.eventName = eventName
        update.eventDate = eventDate
        update.eventTime = eventTime
        update.eventLocation = eventLocation
    }
    
    public func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Exception")
        }
        updateFetchResults()
    }
    
    // TODO: add update event
    
    // ====== DELETE ====== //
    
    public func delete(i: Int) {
        managedObjectContext.delete(self.fetchResults![i])
        save()
    }
}
