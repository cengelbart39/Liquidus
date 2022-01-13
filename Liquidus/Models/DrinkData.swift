//
//  DrinkData.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import Foundation
import SwiftUI

struct DrinkData: Decodable, Encodable {
    
    var isOnboarding = true
    
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
        Constants.coffeeKey: CodableColor(color: .systemBrown),
        Constants.sodaKey: CodableColor(color: .systemGreen),
        Constants.juiceKey: CodableColor(color: .systemOrange)
    ]
    
    var colorChanged: [String:Bool] = [
        Constants.waterKey : false,
        Constants.coffeeKey : false,
        Constants.sodaKey : false,
        Constants.juiceKey : false
    ]
    
    var lastHKSave: Date? = nil
    var healthKitEnabled = false
}
