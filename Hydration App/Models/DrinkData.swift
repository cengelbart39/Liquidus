//
//  DrinkData.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import Foundation
import SwiftUI

struct DrinkData: Decodable, Encodable {
    var drinks = [Drink]()
    var dailyGoal = 2000.0
    var units = Constants.milliliters
    
    var drinkTypes = [Constants.waterKey, "Coffee", "Soda", "Juice"]
    
    var colors: [String:CodableColor] = [
        Constants.waterKey: CodableColor(color: .systemTeal),
        "Coffee": CodableColor(color: UIColor(named: "CoffeeBrown")!),
        "Soda": CodableColor(color: .systemGreen),
        "Juice": CodableColor(color: .systemOrange)
    ]
    
    var selectedDay = Date()
    var selectedWeek = [Date()]
    var lastHKSave: Date? = nil
}
