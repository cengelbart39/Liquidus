//
//  TimePeriod.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 5/28/22.
//

import Foundation

/**
 The time period the user is currently viewing
 */
public enum TimePeriod {
    /// The user is viewing data by a day at a time
    case daily
    
    /// The user is viewing data by a week at a time
    case weekly
    
    /// The user is viewing data by a month at a time
    case monthly
    
    /// The user is viewing data by a half-year at a time
    case halfYearly
    
    /// The user is viewing data by a year at a time
    case yearly
}
