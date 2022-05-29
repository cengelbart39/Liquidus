//
//  Month.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 5/18/22.
//

import Foundation

/**
 A representation of a month
 */
class Month: DatesProtocol {
    /// The type of the `data` property
    typealias DatesData = [Day]
    
    /// The unique id of a specific `Month`
    var id = UUID()
    
    /// The `[Day]` representing the `Day`s in the `Month`
    var data = [Day]()
    
    /// A description of the `Month`
    var description = String()
    
    /// A variation of `description` of the `Month` for accessibility purposes
    var accessibilityDescription = String()
    
    /**
     Get a `Month` for today
     */
    required convenience init() {
        self.init(date: Date.now)
    }
    
    /**
     Get a `Month` for a given `Date`
     - Parameter date: A `Date` somewhere in a month
     */
    required init(date: Date) {
        self.data = self.getMonth(day: date)
        self.description = self.getDescription(day: date)
        self.accessibilityDescription = self.getAccessibilityDescription(day: date)
    }
    
    /**
     Get the first day in the `Month`
     - Returns: The first day in the `Month`
     */
    func firstDay() -> Date {
        if let day = self.data.first?.data {
            return day
        }
        
        return Date()
    }
    
    /**
     Get the last day in the `Month`
     - Returns: The last day in the `Month`
     */
    func lastDay() -> Date {
        if let day = self.data.last?.data {
            return day
        }
        
        return Date()
    }
    
    /**
     Update self to the previous `Month` (i.e. April 2022 > March 2022)
     */
    func prevMonth() {
        // Get the first day in the Month
        let firstDay = self.firstDay()
        
        // Get the first day of the previous month
        if let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDay) {
        
            // Update properties
            self.data = self.getMonth(day: lastMonth)
            self.description = self.getDescription(day: lastMonth)
            self.accessibilityDescription = self.getAccessibilityDescription(day: lastMonth)
        }
    }
    
    /**
     Update self to the next `Month` (i.e. April 2022 > May 2022)
     */
    func nextMonth() {
        // Get the first day in the Month
        let firstDay = self.firstDay()
        
        // Get the first day of the next month
        if let lastMonth = Calendar.current.date(byAdding: .month, value: 1, to: firstDay) {
        
            // Update properties
            self.data = self.getMonth(day: lastMonth)
            self.description = self.getDescription(day: lastMonth)
            self.accessibilityDescription = self.getAccessibilityDescription(day: lastMonth)
        }
    }
    
    /**
     Determines if the next month, relative to `self.data`, is the upcoming month, relative to the current date.
     - Returns: `True` if next month, relative to `self.data`, is the upcoming month, relative to the current date; `False` if not
     */
    func isNextMonth() -> Bool {
        // Get the next month per currentMonth and today
        if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.data[0].data), let upcomingMonth = Calendar.current.date(byAdding: .month, value: 1, to: .now) {
            
            // If both months fall are the same return true
            if Calendar.current.compare(nextMonth, to: upcomingMonth, toGranularity: .month) == .orderedSame {
                
                return true
            }
        }
        
        return false
    }
    
    /**
     Get all `Day`s in a `Month` for the given `Date`
     - Parameter day: A `Date`
     - Returns: A `[Day]` with a `Day` representing each `Day` in the `Month`
     */
    private func getMonth(day: Date) -> [Day] {
        // Date Formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "y"
        
        // Get the current year
        var currentYear = 0
        if let year = Int(formatter.string(from: day)) {
            currentYear = year
        }
        
        // Get the current month
        formatter.dateFormat = "M"
        var currentMonth = 0
        if let month = Int(formatter.string(from: day)) {
            currentMonth = month
        }
        
        // If currentYear and currentMonth are greater than zero...
        if currentYear > 0 && currentMonth > 0 {
            
            // Get date components
            let components = DateComponents(year: currentYear, month: currentMonth)
            
            // Get date from components
            if let date = Calendar.current.date(from: components) {
                
                // Get range for date
                if let range = Calendar.current.range(of: .day, in: .month, for: date) {
                   
                    // Get the max of the range
                    if let max = range.max() {
                        var dates = [Day]()
                        
                        // Generate an array with each date in the month
                        for index in 1...max {
                            if let date = Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth, day: index)) {
                                
                                dates.append(Day(date: date))
                            }
                        }
                        
                        return dates
                    }
                }
            }
        }
        
        // If any of the if or if-let statements fail return an empty array
        return [Day]()
    }
    
    /**
     Get the `description` of the `Month`
     - Parameter day: A `Date`
     - Returns: A `String`  in the format of "Apr 2022"
     */
    private func getDescription(day: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM y"
        
        return formatter.string(from: day)
    }
    
    /**
     Get the Accessibility Description of the `Month`
     - Parameter day: A `Date`
     - Returns: A `String` in the format of "April 2022"
     */
    private func getAccessibilityDescription(day: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM y"
        
        return formatter.string(from: day)
    }
    
    /**
     Determines if two `Month`s are the same
     - Parameters:
        - lhs: The `Month` on the left of the `==`
        - rhs: The `Month` on the right of the `==`
     - Returns: `true` if they're the same; `false` if not
     */
    static func == (lhs: Month, rhs: Month) -> Bool {
        if lhs.data == rhs.data && lhs.description == rhs.description && lhs.accessibilityDescription == rhs.accessibilityDescription {
            
            return true
        }
        
        return false
    }
}
