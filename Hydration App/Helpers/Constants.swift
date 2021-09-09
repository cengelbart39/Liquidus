//
//  Constants.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import Foundation
import SwiftUI

struct Constants {
    
    static var selectDay = "Day"
    static var selectWeek = "Week"
    
    static var milliliters = "mL"
    static var ounces = "oz"
    
    static var waterKey = "Water"
    static var coffeeKey = "Coffee"
    static var sodaKey = "Soda"
    static var juiceKey = "Juice"
    
    static var savedKey = "SavedKey"
    
    static var mlTOoz = 0.033814
    static var ozTOml = 29.57353
    
    static var colors: [String:Color] = [
        Constants.waterKey:Color(.systemTeal),
        Constants.coffeeKey:Color("CoffeeBrown"),
        Constants.sodaKey:Color(.systemGreen),
        Constants.juiceKey:Color(.systemOrange)
    ]
}
