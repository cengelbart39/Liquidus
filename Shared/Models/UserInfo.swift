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
struct UserInfo: Decodable, Encodable, Equatable {
    
    /// Whether or not the user is in onboarding; `true` by default
    var isOnboarding = true

    /// Used in tandem with `dailyTotalToGoal` to reset it when it's a new day
    var currentDay = Date()
    
    /// The user's current progress toward their goal for the current day. Used for the Widget.
    var dailyTotalToGoal = 0.0
    
    /// The Daily Goal set by the user
    var dailyGoal = 2000.0
    
    /// The units used by the user
    var units = Constants.milliliters
    
    /// When the last save to Apple HealthKit was completed; `nil` if it hasn't occured once yet
    var lastHKSave: Date? = nil
    
    /// Whether or not the user has authorized access to their Apple Health data
    var healthKitEnabled = false
    
    static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.isOnboarding == rhs.isOnboarding && Calendar.current.isDate(lhs.currentDay, inSameDayAs: rhs.currentDay) && lhs.dailyTotalToGoal == rhs.dailyTotalToGoal && lhs.dailyGoal == rhs.dailyGoal && lhs.units == rhs.units && lhs.lastHKSave == rhs.lastHKSave && lhs.healthKitEnabled == rhs.healthKitEnabled
    }
}
