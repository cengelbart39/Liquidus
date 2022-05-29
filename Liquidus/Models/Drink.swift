//
//  Drink.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/7/21.
//

import Foundation

/**
 A `class` representing of some drink consumed by the user
 */
class Drink: CustomStringConvertible, Decodable, Encodable, Equatable, Identifiable {
    
    /// The unique if of the specific `Drink`
    var id = UUID()
    
    /// The type of `Drink` that is being consumed
    var type: DrinkType
    
    /// How much of a `Drink` is consumed
    var amount: Double
    
    /// When the `Drink` is consumed
    var date: Date
    
    /**
     A description of the `Drink`, displaying `type`, `amount`, and `date`
     */
    var description: String {
        return "Drink(type: \(type), amount: \(amount), date: \(date.description)"
    }
    
    /**
     Create a `Drink`
     - Parameters:
        - type: The `Drink`'s `DrinkType`
        - amount: The `Drink`'s amount (Double)
        - date: The `Date` the `Drink` was logged
     */
    init(type: DrinkType, amount: Double, date: Date) {
        self.type = type
        self.amount = amount
        self.date = date
    }
    
    /**
     Determines if two `Drink`s are the same
     - Parameters:
        - lhs: The `Drink` on the left side of the `==`
        - rhs: The `Drink` on the right side of the `==`
     - Returns: `true` if they are the same; `false` if they're not
     */
    static func == (lhs: Drink, rhs: Drink) -> Bool {
        return lhs.type == rhs.type && lhs.amount == rhs.amount && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .year) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .month) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .day) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .hour) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .minute) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .second) == .orderedSame
    }
    
    /**
     Generates an array of 9 Water `Drink`s
     - Returns: An array of 9 `Drink`s
     */
    static func getWaterSampleDrinks() -> [Drink] {
        var drinks = [Drink]()
        
        let amounts: [Double] = [100, 200, 300, 400, 500, 400, 300, 200, 100]
        
        for amount in amounts {
            drinks.append(Drink(type: DrinkType.getWater(), amount: amount, date: .now))
        }
        
        return drinks
    }
}
