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
    
    public enum TimePeriod {
        case daily
        case weekly
        case monthly
        case halfYearly
        case yearly
    }
    
    static var total = "TOTAL"
    static var average = "AVERAGE"
    static var dailyAverage = "DAILY AVERAGE"
    
    static var cups = "cups"
    static var flOzUS = "fl oz"
    static var L = "L"
    static var mL = "mL"
    
    static var cupsUS = "Cups (US)"
    static var fluidOuncesUS = "Fluid Ounces (US)"
    static var liters = "Liters"
    static var milliliters = "Milliliters"
    
    static var waterKey = "Water"
    static var coffeeKey = "Coffee"
    static var sodaKey = "Soda"
    static var juiceKey = "Juice"
    static var allKey = "All"
    
    static var savedKey = "SavedKey"
    
    static var sharedKey = "group.com.cengelbart.Liquidus.shared"
    
    static var intakeDailyURL = URL(string: "liquidus://intake/daily")!
    static var logDrinkDailyURL = URL(string: "liquidus://intake/daily/log")!
    static var intakeWeeklyURL = URL(string: "liquidus://intake/weekly")
    static var logDrinkWeeklyURL = URL(string: "liquidus://intake/weekly/log")
    
    static var unitDictionary: [String:UnitVolume] = [
        Constants.cupsUS:UnitVolume.cups,
        Constants.fluidOuncesUS:UnitVolume.fluidOunces,
        Constants.liters:UnitVolume.liters,
        Constants.milliliters:UnitVolume.milliliters
    ]
}
