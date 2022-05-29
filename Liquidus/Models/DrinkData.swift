//
//  DrinkData.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/7/21.
//

import Foundation
import SwiftUI

/**
 A `struct` representing of the information stored locally on device
 */
struct DrinkData: Decodable, Encodable, Equatable {
    
    /// Whether or not the user is in onboarding; `true` by default
    var isOnboarding = true
    
    /// The `Drink`s consumed by the user
    var drinks = [Drink]()
    
    /// The Daily Goal set by the user
    var dailyGoal = 2000.0
    
    /// The units used by the user
    var units = Constants.milliliters
    
    /// The `DrinkType`s the user can use; defaults with Water, Coffee, Soda, and Juice
    var drinkTypes = DrinkType.getDefault()
    
    /// When the last save to Apple HealthKit was completed; `nil` if it hasn't occured once yet
    var lastHKSave: Date? = nil
    
    /// Whether or not the user has authorized access to their Apple Health data
    var healthKitEnabled = false
}
