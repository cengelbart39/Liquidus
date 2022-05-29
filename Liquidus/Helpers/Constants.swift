//
//  Constants.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//

import Foundation
import SwiftUI

/**
 A container for constants used throughout the app
 */
struct Constants {
    
    /// Text for `Day`
    static var selectDay = "Day"
    
    /// Text for `Week`
    static var selectWeek = "Week"
    
    /// Text for Total Data in TrendsChart
    static var total = "TOTAL"
    
    /// Text for Average Data in TrendsChart
    static var average = "AVERAGE"
    
    /// Text for Daily Average Data in TrendsChart
    static var dailyAverage = "DAILY AVERAGE"
    
    /// Cups Abbreviation
    static var cups = "cups"
    
    /// Fluid Ounces Abbreviation
    static var flOzUS = "floz"
    
    /// Liters Abbreviation
    static var L = "L"
    
    /// Milliliters Abbreviation
    static var mL = "mL"
    
    /// Full Unit Name for Cups
    static var cupsUS = "Cups (US)"
    
    /// Full Unit Name of Fluid Ounces
    static var fluidOuncesUS = "Fluid Ounces (US)"
    
    /// Full Unit Name of Liters
    static var liters = "Liters"
    
    /// Full Unit Name of Milliliters
    static var milliliters = "Milliliters"
    
    /// Name of the Default Water `DrinkType`
    static var waterKey = "Water"
    
    /// Name of the Default Coffee `DrinkType`
    static var coffeeKey = "Coffee"
    
    /// Name of the Default Soda `DrinkType`
    static var sodaKey = "Soda"
    
    /// Name of the Default Juice `DrinkType`
    static var juiceKey = "Juice"
    
    /// Name of the Total `DrinkType`
    static var totalKey = "Total"
    
    /// The Total `DrinkType`
    static var totalType = DrinkType(name: "Total", color: CodableColor(color: .systemRed), isDefault: true, enabled: true, colorChanged: false)
    
    /// The UserDefaults key where data is stored
    static var savedKey = "SavedKey"
    
    /// The UserDefaults `suiteName` where user data is stored
    static var sharedKey = "group.com.cengelbart.Liquidus.shared"
    
    /// The UserDefaults `suiteName` used for Unit Testing
    static var unitTestingKey = "group.com.cengelbart.LiquidusTests"
    
    /// The `URL` used to view Daily Intake from the Widget
    static var intakeURL = URL(string: "liquidus://intake")!
    
    /// The `URL` used to view the Drink Logging Form from the Widget
    static var logDrinkURL = URL(string: "liquidus://intake/log")!
        
    /// Unit Dictionary used for Unit Conversion
    static var unitDictionary: [String:UnitVolume] = [
        Constants.cupsUS:UnitVolume.cups,
        Constants.fluidOuncesUS:UnitVolume.fluidOunces,
        Constants.liters:UnitVolume.liters,
        Constants.milliliters:UnitVolume.milliliters
    ]
    
    
}
