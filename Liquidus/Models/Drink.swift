//
//  Drink.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import Foundation

class Drink: CustomStringConvertible, Decodable, Encodable, Equatable, Identifiable {
    var id = UUID()
    var type: DrinkType
    var amount: Double
    var date: Date
    
    var description: String {
        return "Drink(type: \(type), amount: \(amount), date: \(date.description)"
    }
    
    init(type: DrinkType, amount: Double, date: Date) {
        self.type = type
        self.amount = amount
        self.date = date
    }
    
    static func == (lhs: Drink, rhs: Drink) -> Bool {
        if lhs.type == rhs.type && lhs.amount == rhs.amount && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .nanosecond) == .orderedSame {
            return true
        } else {
            return false
        }
    }
    
    static func getWaterSampleDrinks() -> [Drink] {
        var drinks = [Drink]()
        
        let amounts: [Double] = [100, 200, 300, 400, 500, 400, 300, 200, 100]
        
        for amount in amounts {
            drinks.append(Drink(type: DrinkType.getWater(), amount: amount, date: .now))
        }
        
        return drinks
    }
}
