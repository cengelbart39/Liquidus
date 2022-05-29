//
//  Week.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 5/18/22.
//

import Foundation
import SwiftUI

/**
 A representation of a week
 */
class Week: DatesProtocol {
    /// The type of the `data` property
    typealias DatesData = [Day]
    
    /// The unique id of a specific `Week`
    var id = UUID()
    
    /// The `[Day]` representing the `Day`s in the `Week`
    var data = [Day]()
    
    /// A description of the `Week`
    var description = String()
    
    /// A variation of `description` of the `Week` for accessibility purposes
    var accessibilityDescription = String()
    
    /**
     Get a `Week` using the current date
     */
    required convenience init() {
        // Call init(date:) using the current date
        self.init(date: Date.now)
    }
    
    /**
     Get a `Week` using a passed in `Date`
     - Parameter date: A `Date`
     */
    required init(date: Date) {
        // Get the [Day] array
        let week = self.getWeek(date: date)
        
        // Set properties
        self.data = week
        self.description = self.getDescription(week: week)
        self.accessibilityDescription = self.getAccessibilityDescription(week: week)
        
    }
    
    /**
     Get a `Week` using a passed in `[Day]`
     - Parameter days: A `[Day]`
     */
    init(days: [Day]) {
        // Set properties
        self.data = days
        self.description = self.getDescription(week: days)
        self.accessibilityDescription = self.getAccessibilityDescription(week: days)
    }
    
    /**
     Get the first day in the `Week`
     - Returns: The first day in the `Week`
     */
    func firstDay() -> Date {
        // Get the first day and return it
        if let day = self.data.first?.data {
            return day
        }
        
        // If can't return today
        return Date()
    }
    
    /**
     Get the last day in the `Week`
     - Returns: The last day in the `Week`
     */
    func lastDay() -> Date {
        // Get the last day and return it
        if let day = self.data.last?.data {
            return day
        }
        
        // If can't return today
        return Date()
    }
    
    /**
     Update the `Week` to the previous week (i.e. April 3-9, 2022 > March 27 - April 2, 2022)
     */
    func prevWeek() {
        // Get the first day of the week
        let firstDay = self.firstDay()

        // Set back the day to a week ago
        if let prevWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: firstDay) {
            
            // Generate a [Day] using prevWeek
            let week = self.getWeek(date: prevWeek)
            
            // Update properties
            self.data = week
            self.description = self.getDescription(week: week)
            self.accessibilityDescription = self.getAccessibilityDescription(week: week)
        }
    }

    /**
     Update the `Week` to the next week (i.e. April 3-9, 2022 > April 10-16, 2022)
     */
    func nextWeek() {
        // Get the first day of the week
        let firstDay = self.firstDay()

        // Set forward the day by a week
        if let nextWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: firstDay) {
            
            // Generate a [Day] using nextWeek
            let week = self.getWeek(date: nextWeek)
            
            // Update properties
            self.data = week
            self.description = self.getDescription(week: week)
            self.accessibilityDescription = self.getAccessibilityDescription(week: week)
        }
    }
    
    /**
     Determines if the next week, relative to `self.data`, is the upcoming week, relative to the current date.
     - Returns: `True` if so, `False` if not
     */
    func isNextWeek() -> Bool {
        // Get the next week per currentWeek and the upcoming week per today
        if let nextWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: self.firstDay()), let upcomingWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: .now) {
            
            // Return the result of doesDateFallInSameWeek()
            return self.doesDateFallInSameWeek(date1: nextWeek, date2: upcomingWeek)
            
        }
        
        // If if-let fails, always return False
        return false
    }
    
    /**
     Update the current `Week` using the given `Date`
     - Parameter date: A Date
     */
    func update(date: Date) {
        let week = self.getWeek(date: date)
        
        self.data = week
        self.description = self.getDescription(week: week)
        self.accessibilityDescription = self.getAccessibilityDescription(week: week)
        
    }
    
    /**
     Determines if two dates fall in the same week.
     - Parameter date1, date2: Two dates
     - Returns: Whether the `date1` and `date2` fall in the same week; `True` if so, `False` if not.
     */
    private func doesDateFallInSameWeek(date1: Date, date2: Date) -> Bool {
        // Get weeks from date1 and date2
        let week1 = self.getWeek(date: date1)
        let week2 = self.getWeek(date: date2)
        
        // Create a date formatter
        let dateFormatter = DateFormatter()
        
        // Only include the date not time
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // Loop for days in week1
        for dayA in week1 {
            
            // Loop through days in week 2
            for dayB in week2 {
                
                // If two days are the same...
                if dateFormatter.string(from: dayA.data) == dateFormatter.string(from: dayB.data) {
                    return true
                }
            }
        }
        
        // If no two days are the same
        return false
    }

    /**
     Gets the Sunday and Saturday of a week using a given `Date`
     - Parameters day: A `Date` in a week
     - Returns: A `[Date]` containing the Sunday and Saturday of the week
     */
    private func getWeekRange(day: Date) -> [Date] {
        
        // Get the number for the day of the week (Sun = 1 ... Sat = 7)
        let dayNum = Calendar.current.dateComponents([.weekday], from: day).weekday
        
        // If there is a non-nil value...
        if dayNum != nil {
            
            // If it's Sunday...
            if dayNum == 1 {
                // Get the Saturday for that week
                let endDate = Calendar.current.date(byAdding: .day, value: 6, to: day)!
                
                return [day, endDate]
                
            // If it's a day from Monday to Friday...
            } else if dayNum! > 1 && dayNum! < 7 {
                
                // Get the difference between the current day and the Sunday and Saturday of that week
                let startDiff = -1 + dayNum!
                let endDiff = 7 - dayNum!
                
                // Get the exact dates
                let startDate = Calendar.current.date(byAdding: .day, value: -startDiff, to: day)!
                let endDate = Calendar.current.date(byAdding: .day, value: endDiff, to: day)!
                
                return [startDate, endDate]
                
            // If it's Saturday...
            } else if dayNum == 7 {
                // Get the Sunday for that week
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: day)!
                
                return [startDate, day]
                
            } else {
                return [Date]()
            }
            
        } else {
            return [Date]()
        }
    }
    
    /**
     Generates a `[Day]` with each `Day` in the `Week`, using a `Date`
     - Parameter date: A `Date`
     - Returns: A `[Day]` with a `Day` for each day in the `Week`
     */
    private func getWeek(date: Date) -> [Day] {
        // Get the week range
        let weekRange = self.getWeekRange(day: date)
        
        // If the array isn't empty...
        if weekRange.count == 2 {
            
            // Get the exact day for each day of the week
            let sunday = Day(date: weekRange[0])
            let monday = Day(date: Calendar.current.date(byAdding: .day, value: 1, to: sunday.data)!)
            let tuesday = Day(date: Calendar.current.date(byAdding: .day, value: 2, to: sunday.data)!)
            let wednesday = Day(date: Calendar.current.date(byAdding: .day, value: 3, to: sunday.data)!)
            let thursday = Day(date: Calendar.current.date(byAdding: .day, value: 4, to: sunday.data)!)
            let friday = Day(date: Calendar.current.date(byAdding: .day, value: 5, to: sunday.data)!)
            let saturday = Day(date: weekRange[1])
            
            // Update weeksPopulated if false
            
            return [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
        }
        
        // Else return an empty array
        return [Day]()
    }
    
    /**
     Get the `description` for a `Week` using a given `[Day]`
     - Parameter week: A `[Day]` containing the `Day`s in the `Week`
     - Returns: A `String` `description` of the `Week`. Possible Formats: "Apr 3-9, 2022", "Mar 27 - Apr 2, 2022", "Dec 26, 2021 - Jan 2, 2022"
     */
    private func getDescription(week: [Day]) -> String {
        // Create a date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        // Get first and last days in week
        if let first = week.first?.data, let last = week.last?.data {
            
            // If the year is the same
            if Calendar.current.compare(first, to: last, toGranularity: .year) == .orderedSame {
                
                // Get year string
                let year = formatter.string(from: first)
                
                // Format for month
                formatter.dateFormat = "MMM"
                
                // If the month is the same...
                if Calendar.current.compare(first, to: last, toGranularity: .month) == .orderedSame {
                    
                    // Get date1
                    formatter.dateFormat = "MMM d"
                    
                    let date1 = formatter.string(from: first)
                    
                    // Get date2
                    formatter.dateFormat = "d"
                    
                    let date2 = formatter.string(from: last)
                    
                    return "\(date1)-\(date2), \(year)"
                    
                // If not...
                } else {
                    
                    // Formatt for month and day
                    formatter.dateFormat = "MMM d"
                    
                    // Get dates
                    let date1 = formatter.string(from: first)
                    let date2 = formatter.string(from: last)
                    
                    return "\(date1) - \(date2), \(year)"
                    
                }
            } else {
                // Format for month and day
                formatter.dateFormat = "MMM d, yyyy"
                
                // Get dates
                let date1 = formatter.string(from: first)
                let date2 = formatter.string(from: last)
                
                return "\(date1) - \(date2)"
            }
        }
        
        return ""
    }
    
    /**
     Get the Accessibility Description for a `Week`
     - Parameter week: A `[Day]` containing the `Day`s in the `Week`
     - Returns: A `String` `description` of the week. Possible Formats: "Apr 3rd to 9th, 2022", "Mar 27th - Apr 2nd, 2022", "Dec 26th, 2021 to Jan 2nd, 2022"
     */
    private func getAccessibilityDescription(week: [Day]) -> String {
        // Create a date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        // Get first and last days in week
        if let first = week.first?.data, let last = week.last?.data {
            
            // If the year is the same
            if Calendar.current.compare(first, to: last, toGranularity: .year) == .orderedSame {
                
                // Get current year
                let year = formatter.string(from: first)
                
                // Format for month (i.e. Apr)
                formatter.dateFormat = "MMM"
                
                // If the month is the same...
                if Calendar.current.compare(first, to: last, toGranularity: .month) == .orderedSame {
                    
                    // Set formatter (i.e. Apr 8)
                    formatter.dateFormat = "MMM d"
                    
                    // Get date1
                    let date1 = formatter.string(from: first)
                    
                    // Set formatter (i.e. 8)
                    formatter.dateFormat = "d"
                    
                    // Get date2
                    let date2 = formatter.string(from: last)
                    
                    // Set format (i.e. 08)
                    formatter.dateFormat = "dd"
                    
                    // Get suffixes
                    let suffix1 = getDateSuffix(date: formatter.string(from: first))
                    let suffix2 = getDateSuffix(date: formatter.string(from: last))
                    
                    return "\(date1)\(suffix1) to \(date2)\(suffix2), \(year)"
                    
                // If not...
                } else {
                    
                    // Formatt for month and day
                    formatter.dateFormat = "MMM d"
                    
                    // Get month-day strings
                    let date1 = formatter.string(from: first)
                    let date2 = formatter.string(from: last)
                    
                    // Format for day
                    formatter.dateFormat = "d"
                    
                    // Get suffix strings
                    let suffix1 = self.getDateSuffix(date: formatter.string(from: first))
                    let suffix2 = self.getDateSuffix(date: formatter.string(from: last))
                    
                    return "\(date1)\(suffix1) to \(date2)\(suffix2), \(year)"
                    
                }
            // If not
            } else {
                // Format for month and day
                formatter.dateFormat = "MMM d"
                
                // Get month-day strings
                let monthDay1 = formatter.string(from: first)
                let monthDay2 = formatter.string(from: last)
                
                // Format for the day
                formatter.dateFormat = "d"
                
                // Get suffixes
                let suffix1 = self.getDateSuffix(date: formatter.string(from: first))
                let suffix2 = self.getDateSuffix(date: formatter.string(from: last))
                
                // Format for year
                formatter.dateFormat = "yyyy"
                
                // Get year string
                let year1 = formatter.string(from: first)
                let year2 = formatter.string(from: last)
                
                return "\(monthDay1)\(suffix1), \(year1) to \(monthDay2)\(suffix2), \(year2)"
            }
        }
        
        return ""
    }
    
    /**
     Get a suffix for a `Day`
     - Parameter date: A `Sring` with the two digits of the day ("08", "21")
     - Returns: The appropriate suffix: "st", "nd", "rd", "th"
     */
    private func getDateSuffix(date: String) -> String {
        // Get the number of characters in string
        let count = date.count
        
        // Store date in new variable
        var num = date
        
        // If the count is 2
        if count == 2 {
            // If 11, 12, or 13, return "th"
            if date == "11" || date == "12" || date == "13" {
                return "th"
            }
            
            // Otherwise, drop the first character
            num = String(date.dropFirst(1))
        }
        
        switch num {
        case "1":
            return "st"
        case "2":
            return "nd"
        case "3":
            return "rd"
        default:
            return "th"
        }
    }
    
    /**
     Determines if two `Week`s are the same
     - Parameters:
        - lhs: The `Week` on the left of the `==`
        - rhs: The `Week` on the right of the `==`
     - Returns: `true` if they're the same; `false` if not
     */
    static func == (lhs: Week, rhs: Week) -> Bool {
        if lhs.data == rhs.data && lhs.description == rhs.description && lhs.accessibilityDescription == rhs.accessibilityDescription {
            
            return true
        }
        
        return false
    }
}
