//
//  Drink+CoreDataProperties.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 5/31/22.
//
//

import Foundation
import CoreData


extension Drink {

    /**
     Fetch the appropriate `Drink` data
     - Returns: A `Drink` `FetchRequest`
     */
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drink> {
        return NSFetchRequest<Drink>(entityName: "Drink")
    }

    /// The id of the Drink
    @NSManaged public var id: UUID?
    
    /// The amount of the `Drink` consumed
    @NSManaged public var amount: Double
    
    /// The date where the `Drink` was consumed
    @NSManaged public var date: Date
    
    /// The type of `Drink` consumed
    @NSManaged public var type: DrinkType
}

extension Drink : Identifiable {

}

extension Drink {
    static func == (lhs: Drink, rhs: Drink) -> Bool {
        return lhs.amount == rhs.amount && lhs.date.description == rhs.date.description && lhs.type == rhs.type
    }
    
    
}
