//
//  YearMethods.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 5/19/22.
//

import Foundation

/**
 Shared methods utilized by the `HalfYear` and `Year` classes
 */
class YearMethods {
    /**
     Get the Description of a `HalfYear` or `Year`
     - Parameter date: A `Date`
     - Parameter offset: The number of months to set back date by
     - Returns: A `String` in the format of "Nov 2021 - Apr 2022" or "Jun - Dec 2021"
     */
    func getDescription(date: Date, offset: Int) -> String {
        // A Date in the last month of the Half Year or Year
        let currentMonth = date
        
        // A Date in the first month of the Half Year or Year
        var pastMonth = Calendar.current.date(byAdding: .month, value: -offset, to: date)!
        pastMonth = Calendar.current.date(bySetting: .day, value: 1, of: pastMonth)!
        
        // A DateFormatter for the year
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        // Check if the years are the same
        if formatter.string(from: pastMonth) == formatter.string(from: currentMonth) {
            
            // Set the year
            let year = formatter.string(from: currentMonth)
            
            // Set the formatter to "MMM" (i.e. "Apr")
            formatter.dateFormat = "MMM"
            
            // Get the first and last months
            let month1 = formatter.string(from: pastMonth)
            let month2 = formatter.string(from: currentMonth)
            
            // Return the constructed string
            return "\(month1) - \(month2), \(year)"
        
        // If not...
        } else {
            
            // Get the first and last years
            let year1 = formatter.string(from: pastMonth)
            let year2 = formatter.string(from: currentMonth)
            
            // Set the formatter to "MMM" (i.e. "Apr")
            formatter.dateFormat = "MMM"
            
            // Get the first and last months
            let month1 = formatter.string(from: pastMonth)
            let month2 = formatter.string(from: currentMonth)
            
            // Return the constructed string
            return "\(month1) \(year1) - \(month2) \(year2)"
        }
    }
    
    /**
     Get the Accessibility Description of `HalfYear` or `Year`
     - Parameter date: A `Date`
     - Parameter offset: The number of months to set back date by
     - Returns: A String in the format of "Nov 2021 to Apr 2022" or "Jun to Dec 2021"
     */
    func getAccessibilityDescription(date: Date, offset: Int) -> String {
        // A Date in the last month of the Half Year or Year
        let currentMonth = date
        
        // A Date in the first month of the Half Year or Year
        var pastMonth = Calendar.current.date(byAdding: .month, value: -offset, to: date)!
        pastMonth = Calendar.current.date(bySetting: .day, value: 1, of: pastMonth)!
        
        // A DateFormatter for the year
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        // Check if the years are the same
        if formatter.string(from: pastMonth) == formatter.string(from: currentMonth) {
            
            // Set the year
            let year = formatter.string(from: currentMonth)
            
            // Set the formatter to "MMM" (i.e. "Apr")
            formatter.dateFormat = "MMM"
            
            // Get the first and last months
            let month1 = formatter.string(from: pastMonth)
            let month2 = formatter.string(from: currentMonth)
            
            // Return the constructed string
            return "\(month1) to \(month2), \(year)"
        
        // If not...
        } else {
            
            // Get the first and last years
            let year1 = formatter.string(from: pastMonth)
            let year2 = formatter.string(from: currentMonth)
            
            // Set the formatter to "MMM" (i.e. "Apr")
            formatter.dateFormat = "MMM"
            
            // Get the first and last months
            let month1 = formatter.string(from: pastMonth)
            let month2 = formatter.string(from: currentMonth)
            
            // Return the constructed string
            return "\(month1) \(year1) to \(month2) \(year2)"
        }
    }

    /**
     Determines if the given `Month` falls in the same month of today
     - Parameter currentMonth: A `Month`
     - Returns: `True` if the `currentMonth` falls in the same month of today; `False` if not
     */
    func isNextMonth(currentMonth: Month) -> Bool {
        // Get the next month per currentMonth and today
        if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth.data[0]), let upcomingMonth = Calendar.current.date(byAdding: .month, value: 1, to: .now) {
            
            return Calendar.current.compare(nextMonth, to: upcomingMonth, toGranularity: .month) == .orderedSame
        }
            
        return false
    }
}
