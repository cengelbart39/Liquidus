//
//  Hour.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 5/19/22.
//

import Foundation

/**
 A representation a hour of a day
 */
class Hour: DatesProtocol, Equatable {
    typealias DatesData = Date
    
    /// The unique id of the `Hour`
    var id = UUID()
    
    /// The `Date` representing the `Hour`
    var data = Date()
    
    /// A description of the `Hour`
    var description = String()
    
    /// A variation of `description` of the `Hour` for accessibility purposes
    var accessibilityDescription = String()
    
    /**
     Get an `Hour` for today
     */
    required convenience init() {
        self.init(date: Date.now)
    }
    
    /**
     Get an `Hour` for the given `Date`
     - Parameter date: A `Date`
     */
    required init(date: Date) {
        self.data = self.getHour(date: date)
        
        let descr = self.getDescription(date: date)
        self.description = descr
        self.accessibilityDescription = descr
    }
    
    /**
     Given a `Date`, format the date so the time will be XX:00:00 and at 0 nanoseconds
     - Parameter date: A Date
     - Returns: `date` formatted at 0 minutes, seconds, and nanoseconds
     */
    private func getHour(date: Date) -> Date {
        var output = date
        
        // Set minutes, seconds, and nanoseconds to 0
        output = Calendar.current.date(bySetting: .minute, value: 0, of: output)!
        output = Calendar.current.date(bySetting: .second, value: 0, of: output)!
        output = Calendar.current.date(bySetting: .nanosecond, value: 0, of: output)!
        output = Calendar.current.date(byAdding: .hour, value: -1, to: output)!
        
        // Return updated date
        return output
    }
    
    /**
     Given a `Date`, generate the appropriate `description` and `accessibilityDescription`
     - Parameter date: A `Date`
     - Returns: A `String` description in the format of `"XX AM"` or `"XX PM"`
     */
    private func getDescription(date: Date) -> String {
        // Get the hour of the given date
        let component = Calendar.current.dateComponents([.hour], from: date)
        
        // If the component exists...
        if let hour = component.hour {
            
            // If 0, return 12 AM
            if hour == 0 {
                return "12 AM"
            
            // If 1-11, return X AM
            } else if hour >= 1 && hour <= 11 {
                return "\(hour) AM"
                
            // If 12, return 12 PM
            } else if hour == 12 {
                return "12 PM"
                
            // If 13-23, return X-12 PM
            } else if hour >= 13 && hour <= 23 {
                return "\(hour-12) PM"
                
            }
        }
        
        // If if-let fails, return empty string
        return ""
    }
    
    /**
     Determines if two Hours are the same
     - Parameters:
        - lhs: The `Hour` on the left of `==`
        - rhs: The `Hour` on the right of `==`
     - Returns: Whether or not `lhs` and `rhs` are the same `Hour`; `True` if so; `False` if not
     */
    static func == (lhs: Hour, rhs: Hour) -> Bool {
        
        if Calendar.current.compare(lhs.data, to: rhs.data, toGranularity: .hour) == .orderedSame && Calendar.current.compare(lhs.data, to: rhs.data, toGranularity: .day) == .orderedSame && Calendar.current.compare(lhs.data, to: rhs.data, toGranularity: .month) == .orderedSame && Calendar.current.compare(lhs.data, to: rhs.data, toGranularity: .year) == .orderedSame && lhs.description == rhs.description && lhs.accessibilityDescription == rhs.accessibilityDescription {
            
            return true
        }
        
        return false
    }
}
