//
//  Year.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 5/18/22.
//

import Foundation

/**
 A representation of a year
 */
class Year: YearMethods, DatesProtocol {
    /// The type of the `data` property
    typealias DatesData = [Month]
    
    /// The unique id of a specific `Year`
    var id = UUID()
    
    /// The `[Month]` representing the `Month`s in the `Year`
    var data = [Month]()
    
    /// A description of the `Year`
    var description = String()
    
    /// A variation of `description` of the `Year` for accessibility purposes
    var accessibilityDescription = String()
    
    /**
     Get a `Year` using today
     */
    required convenience override init() {
        self.init(date: Date.now)
    }
    
    /**
     Get a `Year` using the given `Date`
     - Parameter date: A `Date`
     */
    required init(date: Date) {
        // Call YearMethods' init()
        super.init()
        
        // Set properties
        self.data = self.getYear(date: date)
        self.description = super.getDescription(date: date, offset: 12)
        self.accessibilityDescription = super.getAccessibilityDescription(date: date, offset: 12)
    }
    
    /**
     Get the first day of the first month
     - Returns: The first day of the first month
     */
    func firstMonth() -> Date {
        // Get and return the first day of the first month
        if let month = data.first?.firstDay() {
            return month
        }
        
        // Return today if if-let fails
        return Date()
    }
    
    /**
     Get the first day of the last month
     - Returns: The first day of the last month
     */
    func lastMonth() -> Date {
        // Get and return the first day of the last month
        if let month = data.last?.firstDay() {
            return month
        }
        
        // Return today if if-let fails
        return Date()
    }
    
    /**
     Set the `Year` back by a month
     */
    func prevYear() {
        // Get the first day of the last month of Year
        let lastDay = self.lastMonth()
        
        // Set lastYear back by a month
        if let lastYear = Calendar.current.date(byAdding: .month, value: -1, to: lastDay) {
        
            // Update properties
            self.data = self.getYear(date: lastYear)
            self.description = super.getDescription(date: lastYear, offset: 11)
            self.accessibilityDescription = super.getAccessibilityDescription(date: lastYear, offset: 11)
        }
    }
    
    /**
     Set the `Year` forward by a month
     */
    func nextYear() {
        // Get the first day of the last month of Year
        let lastDay = self.lastMonth()
        
        // Set lastYear back by a month
        if let lastYear = Calendar.current.date(byAdding: .month, value: 1, to: lastDay) {
        
            // Update properties
            self.data = self.getYear(date: lastYear)
            self.description = super.getDescription(date: lastYear, offset: 11)
            self.accessibilityDescription = super.getAccessibilityDescription(date: lastYear, offset: 11)
        }
    }
    
    /**
     Determines if the next year, relative to `self.data`, is the upcoming year, relative to the current date.
     - Returns: `True` if the next year, relative to `self.data`, is the upcoming year, relative to the current date; `False` if not
     */
    func isNextYear() -> Bool {
        // Get last month in year and call isNextMonth()
        if let lastMonth = self.data.last {
            return super.isNextMonth(currentMonth: lastMonth)
        }
        
        // If can't, always return false
        return false
    }
    
    /**
     Get the `Year` for a given `Date`
     - Parameter date: A `Date`
     - Returns: A `[Month]` for each month in the `Year`
     */
    private func getYear(date: Date) -> [Month] {
        // Create an empty array for the months in the year
        var output = [Month]()
        
        // Get a day in each month of 12-month period
        for index in -11...0 {
            if let newDate = Calendar.current.date(byAdding: .month, value: index, to: date) {
                output.append(Month(date: newDate))
            }
        }
        
        return output
    }
    
    /**
     Determines if two `Year`s are the same
     - Parameters:
        - lhs: The `Year` on the left of the `==`
        - rhs: The `Year` on the right of the `==`
     - Returns: `true` if they're the same; `false` if not
     */
    static func == (lhs: Year, rhs: Year) -> Bool {
        if lhs.data == rhs.data && lhs.description == rhs.description && lhs.accessibilityDescription == rhs.accessibilityDescription {
            
            return true
        }
        
        return false
    }
    
}
