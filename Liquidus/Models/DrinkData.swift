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
    
    var defaultDrinkTypes = [Constants.waterKey, Constants.coffeeKey, Constants.sodaKey, Constants.juiceKey]
    var customDrinkTypes: [String] = []
    
    var enabled: [String: Bool] = [
        Constants.waterKey:true,
        Constants.coffeeKey:true,
        Constants.sodaKey:true,
        Constants.juiceKey:true
    ]
    
    var colors: [String:CodableColor] = [
        Constants.waterKey: CodableColor(color: .systemTeal),
        Constants.coffeeKey: CodableColor(color: UIColor(named: "CoffeeBrown")!),
        Constants.sodaKey: CodableColor(color: .systemGreen),
        Constants.juiceKey: CodableColor(color: .systemOrange)
    ]

    var lastHKSave: Date? = nil
}
