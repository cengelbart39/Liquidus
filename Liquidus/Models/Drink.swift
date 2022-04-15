//
//  Drink.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import Foundation

class Drink: Decodable, Encodable, Equatable, Identifiable {
    var id = UUID()
    var type: DrinkType
    var amount: Double
    var date: Date
    
    init(type: DrinkType, amount: Double, date: Date) {
        self.type = type
        self.amount = amount
        self.date = date
    }
    
    static func == (lhs: Drink, rhs: Drink) -> Bool {
        if lhs.type == rhs.type && lhs.amount == rhs.amount && lhs.date == rhs.date {
            return true
        } else {
            return false
        }
    }
}
