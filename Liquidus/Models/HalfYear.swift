//
//  HalfYear.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 5/18/22.
//

import Foundation

/**
 A representation of a half-year (6-month period)
 */
class HalfYear: YearMethods, DatesProtocol {
    /// The type of the `data` property
    typealias DatesData = [Week]
    
    /// The unique id of a specific `Week`
    var id = UUID()
    
    /// The `[Week]` representing the `Week`s in the `HalfYear`
    var data = [Week]()
    
    /// A description of the `HalfYear`
    var description = String()
    
    /// A variation of `description` of the `HalfYear` for accessibility purposes
    var accessibilityDescription = String()
    
    /**
     Get a `HalfYear` using today
     */
    required convenience override init() {
        self.init(date: Date.now)
    }
    
    /**
     Get a `HalfYear` using the given `Date`
     - Parameter date: A `Date`
     */
    required init(date: Date) {
        // Call YearMethods' init()
        super.init()
        
        // Set Properties
        self.data = self.getWeeksForHalfYear(months: super.getYear(date: date))
        self.description = super.getDescription(date: date, offset: 6)
        self.accessibilityDescription = super.getAccessibilityDescription(date: date, offset: 6)
    }
    
    /**
     Gets the first day in the first month of the `HalfYear`
     - Returns: A `Date` that's the first day in the first month of the `HalfYear`
     */
    func firstMonth() -> Date {
        // Get the first day in the first month and return it
        if let month = self.data.first?.data.first?.data {
            return month
        }
        
        // Return today if if-let fails
        return Date()
    }
    
    /**
     Gets the first day in the last month of the `HalfYear`
     - Returns: A `Date` that's the first day in the last month of the Half Year
     */
    func lastMonth() -> Date {
        // Get the first day in the last month and return it
        if let month = self.data.last?.data.first?.data {
            return Month(date: month).firstDay()
        }
        
        // Return today if if-let fails
        return Date()
    }
    
    /**
     Set back the `HalfYear` by a month
     */
    func prevHalfYear() {
        // Get the first day of the last month of the Half Year
        let lastDay = self.lastMonth()
        
        // Set lastDay by back a month
        if let lastHalfYear = Calendar.current.date(byAdding: .month, value: -1, to: lastDay) {
        
            // Update properties
            self.data = self.getWeeksForHalfYear(months: super.getYear(date: lastHalfYear))
            self.description = super.getDescription(date: lastHalfYear, offset: 6)
            self.accessibilityDescription = super.getAccessibilityDescription(date: lastHalfYear, offset: 6)
        }
    }
    
    /**
     Set forward the `HalfYear` by a month
     */
    func nextHalfYear() {
        // Get the first day of the last month of the Half Year
        let lastDay = self.lastMonth()
        
        // Set lastDay forward by a month
        if let lastHalfYear = Calendar.current.date(byAdding: .month, value: 1, to: lastDay) {
        
            // Update properties
            self.data = self.getWeeksForHalfYear(months: super.getYear(date: lastHalfYear))
            self.description = super.getDescription(date: lastHalfYear, offset: 6)
            self.accessibilityDescription = super.getAccessibilityDescription(date: lastHalfYear, offset: 6)
        }
    }
    
    /**
     Determines if the next half year, relative to `self.data`, is the upcoming half year, relative to the current date.
     - Returns: `True` if the next half year, relative to `self.data`, is the upcoming half year, relative to the current date; `False` if not
     */
    func isNextHalfYear() -> Bool {
        // Get the first day of the last month
        let lastMonth = self.lastMonth()
        
        // Return the result of isNextMonth()
        return super.isNextMonth(currentMonth: Month(date: lastMonth))
    }
    
    /**
     Convert a `[Month]` to a `[Week]` cutting off dates not in range
     - Parameter months: A 12-element `[Month]`
     - Returns: A `[Week]` retaining the last 6 months of `months`
     */
    private func getWeeksForHalfYear(months: [Month]) -> [Week] {
        // Array to store weeks
        var weeks = [Week]()
        
        var usedMonths = [Month]()
        for index in 6...11 {
            usedMonths.append(months[index])
        }
        
        // Tracks how many months are processed
        var monthCount = 0
        
        // Loop through halfYear
        for i1 in 0..<usedMonths.count {
            
            // Loop through the indicies of month incrementing by 7
            for i2 in stride(from: 0, through: usedMonths[i1].data.count, by: 7) {
                
                // When i1 is 0 and i2 is not 0 OR the last week contains the associated day
                if !(i1 > 0 && i2 == 0) || !(weeks.last?.data.contains(usedMonths[i1].data[i2]) ?? true) {
                    // If index doesn't exceed the count of month
                    if i2 < usedMonths[i1].data.count {
                        
                        // Append the week for the specified day using i1 and i2
                        weeks.append(Week(date: usedMonths[i1].data[i2].data))
                        
                    // If index is the same or exceeds the count of month
                    } else if i2 >= usedMonths[i1].data.count {
                        
                        // Assign i2 a new variable
                        var i = i2
                        
                        // Decrement i until i is less than the count of the given week
                        while i >= usedMonths[i1].data.count {
                            i -= 1
                        }
                        
                        // Append the week for the specified day using i1 and i
                        weeks.append(Week(date: usedMonths[i1].data[i].data))
                    }
                }
            }
            
            // Increment monthCount
            monthCount += 1
        }
        
        // Remove any dates that are not in the first month
        weeks[0].data = weeks[0].data.filter { $0.data >= usedMonths[0].firstDay() }
        weeks[0] = Week(days: weeks[0].data)
        
        // Get the count of the last month in dictionary
        let dCount = weeks.count-1
        
        // Get the count of the last month in halfYear
        let hCount = usedMonths.count-1
        
        // Filter out any days past the last day in the half year
        weeks[dCount].data = weeks[dCount].data.filter { $0.data <= usedMonths[hCount].lastDay() }
        weeks[dCount] = Week(days: weeks[dCount].data)
        
        // Return week arangement of the half year
        return weeks
    }
    
    /**
     Determines if two `HalfYear`s are the same
     - Parameters:
        - lhs: The `HalfYear` on the left of the `==`
        - rhs: The `HalfYear` on the right of the `==`
     - Returns: `true` if they're the same; `false` if not
     */
    static func == (lhs: HalfYear, rhs: HalfYear) -> Bool {
        if lhs.data == rhs.data && lhs.description == rhs.description && lhs.accessibilityDescription == rhs.accessibilityDescription {
            
            return true
        }
        
        return false
    }
}
