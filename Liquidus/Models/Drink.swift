//
//  Drink.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import Foundation

class Drink: Decodable, Encodable, Identifiable {
    var id = UUID()
    var type: String
    var amount: Double
    var date: Date
    
    init(type: String, amount: Double, date: Date) {
        self.type = type
        self.amount = amount
        self.date = date
    }
}
