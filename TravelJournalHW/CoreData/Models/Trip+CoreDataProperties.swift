//
//  Trip+CoreDataProperties.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 07.11.2025.
//
//

public import Foundation
public import CoreData


public typealias TripCoreDataPropertiesSet = NSSet

extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var name: String?
    @NSManaged public var about: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var days: NSSet?

}

// MARK: Generated accessors for days
extension Trip {

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: Day)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: Day)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSSet)

}
