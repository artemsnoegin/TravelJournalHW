//
//  CoreDataManager.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 07.11.2025.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createTrip(name: String, about: String, days: NSSet, imagePath: String) -> Trip {
        
        let trip = Trip(context: context)
        trip.name = name
        trip.about = about
        trip.days = days
        trip.imagePath = imagePath
        
        saveContext()
        
        return trip
    }
    
    func fetchTrips() -> [Trip] {
        
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        do {
            return try context.fetch(request)
        }
        catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteTrip(_ trip: Trip) {
        
        context.delete(trip)
    }
    
    func createDay(name: String, about: String, trip: Trip, imagesDirectoryPath: String) -> Day {
        
        let day = Day(context: context)
        day.name = name
        day.about = about
        day.trip = trip
        day.imagesDirectoryPath = imagesDirectoryPath
        
        saveContext()
        
        return day
    }
    
    func fetchDays(for trip: Trip) -> [Day] {
        
        let request: NSFetchRequest<Day> = Day.fetchRequest()
        let predicate = NSPredicate(format: "trip == %@", trip)
        request.predicate = predicate
        
        do {
            return try context.fetch(request)
        }
        catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func saveContext() {
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
