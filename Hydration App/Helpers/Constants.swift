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
    
    static var mL = "mL"
    static var flOzUS = "fl oz"
    static var flOzIM = "fl oz"
    
    static var milliliters = "Milliliters"
    static var fluidOuncesUS = "Fluid Ounces (US)"
    static var fluidOuncesIM = "Fluid Ounces (Imperial)"
    
    static var waterKey = "Water"
    static var coffeeKey = "Coffee"
    static var sodaKey = "Soda"
    static var juiceKey = "Juice"
    
    static var savedKey = "SavedKey"
    
    static var colors: [String:Color] = [
        Constants.waterKey:Color(.systemTeal),
        Constants.coffeeKey:Color("CoffeeBrown"),
        Constants.sodaKey:Color(.systemGreen),
        Constants.juiceKey:Color(.systemOrange)
    ]
}
