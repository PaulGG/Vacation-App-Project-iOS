//
//  ModelProcessor.swift
//  CSE 335 Vacation App Project
//
//  Created by Paul Gellai on 11/9/18.
//  Copyright © 2018 Paul Gellai. All rights reserved.
//
// This file is the model file and contains all classes pertaining to the Model part of the MVC architecture. 

import Foundation
import CoreData
import UIKit
import MapKit

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
    
    public func addFlight(toDest: Bool, date: String, duration: Int, flyingFrom: String, flyingTo: String, gate: String, flightTime: String?) {
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
        if flightTime != nil {
            flightAdding.flightTime = flightTime
        } else {
            flightAdding.flightTime = "Please enter manually."
        }
        // About here is where things get a bit complicated. We have two scenarios: The user inputs a valid IATA city code, or they don't. If they decide to do so,
        // we should run a secondary web API in accordance with the one that adds flights automatically by IATA code, to get the city location name of where
        // the IATA code is. The reason to do this is so Apple's MKLocalSearch service can find the proper location the user has specified, as Apple is unable to
        // easily locate many IATA city codes. This is unfortunately a limiting feature of the flights web API used prior.
        
        // If the user enters something that is not an IATA code or has spaces in the name (example 'New York City'), the URL may be nil and the API should not
        // be called, or its results should be discarded if there is an error found.
        let toQuery = buildQuery(string: "https://aviation-edge.com/v2/public/cities?key=17df8d-586cdb&code=\(flightAdding.flyingTo!)", isDestination: true, object: flightAdding)
        if let unwrappedQuery : URLSessionDataTask = toQuery {
            unwrappedQuery.resume()
        } else {
            flightAdding.nameOfFlyingTo = flightAdding.flyingTo
        }
        // Call 2  - so we can find the location of where we fly FROM //
        let fromQuery = buildQuery(string: "https://aviation-edge.com/v2/public/cities?key=17df8d-586cdb&code=\(flightAdding.flyingFrom!)", isDestination: false, object: flightAdding)
        if let unwrappedQuery: URLSessionDataTask = fromQuery {
            unwrappedQuery.resume()
        } else {
            flightAdding.nameOfFlyingFrom = flightAdding.flyingFrom
        }
        save()
    }
    
    // See above 'addFlight' method to see where things get complicated.
    public func updateFlight(at: Int, toDest: Bool, date: String, duration: Int, flyingFrom: String, flyingTo: String, gate: String, flightTime: String) {
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
        update.flightTime = flightTime
        // Json Call
        // Call 1 //
        let toQuery = buildQuery(string: "https://aviation-edge.com/v2/public/cities?key=17df8d-586cdb&code=\(update.flyingTo!)", isDestination: true, object: update)
        if let unwrappedQuery : URLSessionDataTask = toQuery {
            unwrappedQuery.resume()
        } else {
            update.nameOfFlyingTo = update.flyingTo
        }
        // Call 2 //
        let fromQuery = buildQuery(string: "https://aviation-edge.com/v2/public/cities?key=17df8d-586cdb&code=\(update.flyingFrom!)", isDestination: false, object: update)
        if let unwrappedQuery : URLSessionDataTask = fromQuery {
            unwrappedQuery.resume()
        } else {
            update.nameOfFlyingFrom = update.flyingFrom
        }
        save()
    }
    
    // Saves the newly added instances in the managed object context to the core data stores.
    public func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Exception")
        }
        // Update fetch results is necessary so the model has the latest things from the database.
        // This was included in this function becuase many methods which call it require the reloading of
        // fetch results.
        updateFetchResults()
    }
    
    // ====== DELETE ====== //
    
    public func delete(i: Int) {
        managedObjectContext.delete(self.fetchResults![i])
        save()
    }
    
    // This is the method which builds a query for the find location based off of IATA code API call.
    public func buildQuery(string: String, isDestination: Bool, object: Flight) -> URLSessionDataTask? {
        let url = URL(string: string)
        let urlSession = URLSession.shared
        // If the URL is valid, proceed. If not (due to user input), return nil.
        if url != nil {
            let toQuery = urlSession.dataTask(with: url!, completionHandler: {data, response, error -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                }
                // If json result is valid, proceed.
                if let jsonResult = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSArray) {
                    let foo = jsonResult[0] as! NSDictionary
                    if let cityName = foo["name"] as? NSString {
                        // User input is valid. Proceed to use the data from the web api call.
                        DispatchQueue.main.async {
                            if isDestination {
                                object.nameOfFlyingTo = cityName as String
                            } else {
                                object.nameOfFlyingFrom = cityName as String
                            }
                            self.save()
                        }
                    } else {
                        // Json result is not valid. Add normal user inputted values.
                        DispatchQueue.main.async {
                            if isDestination {
                                object.nameOfFlyingTo = object.flyingTo
                            } else {
                                object.nameOfFlyingFrom = object.flyingFrom
                            }
                            self.save()
                        }
                    }
                } else {
                    // Json result is not valid. Add normal user inputted values.
                    DispatchQueue.main.async {
                        if isDestination {
                            object.nameOfFlyingTo = object.flyingTo
                        } else {
                            object.nameOfFlyingFrom = object.flyingFrom
                        }
                        self.save()
                    }
                }
            })
            return toQuery
        } else {
            // URL is invalid, meaning the user inputted spaces or multiple words. we need to return nil.
            return nil
        }
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
        save()
    }
    
    public func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Exception")
        }
        // Update fetch results is necessary so the model has the latest things from the database.
        // This was included in this function becuase many methods which call it require the reloading of
        // fetch results.
        updateFetchResults()
    }
    
    // TODO: add update event
    
    // ====== DELETE ====== //
    
    public func delete(i: Int) {
        managedObjectContext.delete(self.fetchResults![i])
        save()
    }
}

// A special singleton instance class used to easily transport data between viewcontrollers without the need for segues.
// Holds instances of MKMapItems (cannot be easily stored in core data), and they do not need to be stored in CoreData due
// to the high possiblity of the user having different locations around them when they move, or when the user changes the
// filter query. 
class NearbyLocations {
    private static var nearbyLocations: NearbyLocations?
    var locations: [MKMapItem]
    var filter: String?
    
    private init() {
        self.locations = [MKMapItem]()
        self.filter = "nearby"
    }
    
    static func getInstance() -> NearbyLocations {
        if nearbyLocations == nil {
            nearbyLocations = NearbyLocations()
        }
        return nearbyLocations!
    }
}
