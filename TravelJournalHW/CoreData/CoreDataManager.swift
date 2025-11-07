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
    
    func createTrip(name: String, about: String, days: NSSet, imagePath: String) {
        
        let trip = Trip(context: context)
        trip.name = name
        trip.about = about
        trip.days = days
        trip.imagePath = imagePath
        
        saveContext()
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
    
    func saveContext() {
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
