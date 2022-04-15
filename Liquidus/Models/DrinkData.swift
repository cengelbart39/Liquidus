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
    
    var drinkTypes = DrinkType.getDefault()
    
    var lastHKSave: Date? = nil
    var healthKitEnabled = false
}
