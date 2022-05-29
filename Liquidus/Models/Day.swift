//
//  Day.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 5/18/22.
//

import Foundation

/**
 A representation of a single day
 */
class Day: DatesProtocol {
    /// The type of the `data` property
    typealias DatesArray = Date
    
    /// The unique id of a specific `Day`
    var id = UUID()
    
    /// The `Date` representing the `Day`
    var data = Date()
    
    /// A description of the `Day`
    var description = String()
    
    /// A variation of `description` of the `Day` for accessibility purposes
    var accessibilityDescription = String()
    
    /**
     Get a `Day`, using the current day
     */
    required convenience init() {
        // Call init(date:) passing in Date.now
        self.init(date: Date.now)
    }
    
    /**
     Get a `Day`, using the given `Date`
     - Parameter date: A `Date`
     */
    required init(date: Date) {
        self.data = date
        self.description = self.getDescription(date: date)
        self.accessibilityDescription = self.getAccessibilityDescription(date: date)
    }
    
    /**
     Update `self` to the next day (i.e. April 8 > April 9)
     */
    func nextDay() {
        // Get the following day
        if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: self.data) {
            
            // Update properties
            self.data = nextDay
            self.description = self.getDescription(date: nextDay)
            self.accessibilityDescription = self.getAccessibilityDescription(date: nextDay)
        }
        
    }
    
    /**
     Update `self` to the previous day (i.e. April 8 > April 7)
     */
    func prevDay() {
        // Get the previous day
        if let prevDay = Calendar.current.date(byAdding: .day, value: -1, to: self.data) {
            
            // Update properties
            self.data = prevDay
            self.description = self.getDescription(date: prevDay)
            self.accessibilityDescription = self.getAccessibilityDescription(date: prevDay)
        }
    }
    
    /**
     Determines if the next day is tomorrow relative to the current date.
     - Returns: `True` f the next day is tomorrow relative to the current date; `False` if not
     */
    func isTomorrow() -> Bool {
        // Get the following day relative to self.data
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: self.data)!
        
        // Return the result of isDateInTomorrow using nextDay
        return Calendar.current.isDateInTomorrow(nextDay)
    }
    
    /**
     Update the properties of `self` using the current date
     */
    func today() {
        self.data = Date.now
        self.description = self.getDescription(date: Date.now)
        self.accessibilityDescription = self.getAccessibilityDescription(date: Date.now)
    }
    
    /**
     Update the proprties of `self` using the passed in `Date`
     - Parameter date: A `Date`
     */
    func update(date: Date) {
        self.data = date
        self.description = self.getDescription(date: date)
        self.accessibilityDescription = self.getAccessibilityDescription(date: date)
    }
    
    /**
     For the `Date` stored in `self.data`, get an `Hour` for each hour in the `Day`
     - Returns: A `[Hour]` containing each `Hour` in the `Date` stored in `self.data`
     */
    func getHours() -> [Hour] {
        // Empty Hours array
        var hours = [Hour]()
        
        // Get the day, month, and year components of self.data
        let components = Calendar.current.dateComponents([.day, .month, .year], from: self.data)

        // Check the components aren't nil
        if let day = components.day, let month = components.month, let year = components.year {
            
            // Loop through the hours of self.data
            for index in 1...24 {
                
                // Create a date for the given components and index
                // and make sure it is not nil
                if let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: index, minute: 0, second: 0, nanosecond: 0)) {
                    
                    // Append the Date as an Hour
                    hours.append(Hour(date: date))
                }
            }
        }
        
        // Return the hours array
        return hours
        
    }
    
    /**
     Get the `description` for a given `Date`
     - Parameter date: A `Date`
     - Returns: A `String` description in the format of `"Apr 8, 2022"`
     */
    private func getDescription(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter.string(from: date)
    }
    
    /**
     Get the Accessibility Description for a given date
     - Parameter date: A `Date`
     - Returns: A `String` description in the format of `"Apr 8, 2022"`, `"Today"`, `"Yesterday"`, or `"Tomorrow"`
     */
    private func getAccessibilityDescription(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        
        return formatter.string(from: date)
    }
    
    /**
     Determines if two Day are the same object
     - Parameters:
        - lhs: The `Day` on the left side of `==`
        - rhs: The `Day` on the right side of `==`
     - Returns: Whether `lhs` and `rhs` are the same `Day`; `True` if so; `False` if not
     */
    static func == (lhs: Day, rhs: Day) -> Bool {
        if lhs.data.description == rhs.data.description && lhs.description == rhs.description && lhs.accessibilityDescription == rhs.accessibilityDescription {
            
            return true
            
        }
        
        return false
    }
}
