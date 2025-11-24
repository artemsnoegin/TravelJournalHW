//
//  Day+CoreDataProperties.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 07.11.2025.
//
//

public import Foundation
public import CoreData


public typealias DayCoreDataPropertiesSet = NSSet

extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var name: String?
    @NSManaged public var about: String?
    @NSManaged public var imagesDirectoryPath: String?
    @NSManaged public var trip: Trip?

}

extension Day : Identifiable {

}
