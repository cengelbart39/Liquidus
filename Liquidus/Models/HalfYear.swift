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
        self.data = self.getHalfYear(date: date)
        self.description = super.getDescription(date: date, offset: 6)
        self.accessibilityDescription = super.getAccessibilityDescription(date: date, offset: 6)
    }
    
    /**
     Gets the first day in the first month of the `HalfYear`
     - Returns: A `Date` that's the first day in the first month of the `HalfYear`
     */
    func firstMonth() -> Date {
        // Get the first day in the first month and return it
        if let month = self.data.first?.firstDay() {
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
        if let month = self.data.last?.lastDay() {
            let components = Calendar.current.dateComponents([.year, .month], from: month)
            
            if let year = components.year, let month = components.month {
                return Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
            }
        }
        
        // Return today if if-let fails
        return Date()
    }
    
    /**
     Set back the `HalfYear` by a month
     */
    func prevHalfYear() {
        // Get the first day of the last month of the Half Year
        let firstMonth = self.firstMonth()
        let lastMonth = self.lastMonth()
        
        if let newStart = Calendar.current.date(byAdding: .month, value: -1, to: firstMonth), let newEnd = Calendar.current.date(byAdding: .day, value: -1, to: lastMonth) {
            
            self.data = self.updateDataPrevious(start: newStart, end: newEnd)
            self.description = super.getDescription(date: newEnd, offset: 6)
            self.accessibilityDescription = super.getAccessibilityDescription(date: newEnd, offset: 6)
        }
    }
    
    /**
     Set forward the `HalfYear` by a month
     */
    func nextHalfYear() {
        // Get the first day of the last month of the Half Year
        let firstMonth = self.firstMonth()
        let lastMonth = self.lastMonth()
        
        if let nextMonth = Calendar.current.date(byAdding: .month, value: 2, to: lastMonth) {
            
            if let newStart = Calendar.current.date(byAdding: .month, value: 1, to: firstMonth), let newEnd = Calendar.current.date(byAdding: .day, value: -1, to: nextMonth) {
            
                self.data = self.updateDataNext(start: newStart, end: newEnd)
                self.description = super.getDescription(date: newEnd, offset: 6)
                self.accessibilityDescription = super.getAccessibilityDescription(date: newEnd, offset: 6)
            }
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
     Get a `[Week]` with the days during the last 5 months, relative to a `Date`, cutting off dates not in range
     - Parameter date: A day in the last month of the `HalfYear`
     - Returns: A `[Week]` with the days during the last 5 months, relative to a `date`
     */
    private func getHalfYear(date: Date) -> [Week] {
        // Array to store weeks
        var weeks = [Week]()
        
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        
        if let year = components.year, let month = components.month {
            
            let firstDayCurrMonth = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
            
            let fiveMonthsAgo = Calendar.current.date(byAdding: .month, value: -5, to: firstDayCurrMonth)!

            var lastDayCurrMonth = Calendar.current.date(byAdding: .month, value: 1, to: firstDayCurrMonth)!
            lastDayCurrMonth = Calendar.current.date(byAdding: .day, value: -1, to: lastDayCurrMonth)!
            
            var currentDay = Day(date: fiveMonthsAgo)
            
            while (!weeks.contains(where: { w in
                w.data.contains(lastDayCurrMonth)
            })) {
                let newWeek = Week(date: currentDay.data)
                
                weeks.append(newWeek)
                
                currentDay = Day(date: Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDay.data)!)
            }
            
            let firstWeek = weeks[0].data.filter {
                $0 >= fiveMonthsAgo
            }
            
            weeks[0] = Week(days: firstWeek)
            
            let lastIndex = weeks.count-1
            
            let lastWeek = weeks[lastIndex].data.filter {
                $0 <= lastDayCurrMonth
            }
            
            weeks[lastIndex] = Week(days: lastWeek)
        }
        
        // Return week arangement of the half year
        return weeks
    }
    
    /**
     Updates the current data when progressing to the next `HalfYear` using the pre-exisiting data
     - Parameters:
        - start: The new start date for data
        - end: The new end date for data
     - Returns: Updated data
     */
    private func updateDataNext(start: Date, end: Date) -> [Week] {
        let data = self.data
        
        var startIndex = 0
        for index in 0..<data.count {
            if data[index].data.contains(start) {
                startIndex = index
                break
            }
        }
        
        var newData = data
        newData.removeSubrange(0..<startIndex)
        
        let first = newData[0].data.filter { $0 >= start }
        newData[0] = Week(days: first)
        
        let endIndex = newData.count-1
        var currentDay = newData[endIndex].firstDay()
        
        newData[endIndex] = Week(date: currentDay)
        
        while (!newData.contains(where: { w in
            w.data.contains(end)
        })) {
            
            currentDay = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDay)!
            
            newData.append(Week(date: currentDay))
        }
        
        let last = newData[newData.endIndex-1].data.filter { $0 <= end }
        newData[newData.endIndex-1] = Week(days: last)
        
        return newData
    }
    
    /**
     Updates the current data when progressing to the previous `HalfYear` using the pre-exisiting data
     - Parameters:
        - start: The new start date for data
        - end: The new end date for data
     - Returns: Updated data
     */
    private func updateDataPrevious(start: Date, end: Date) -> [Week] {
        let data = self.data
        
        var endIndex = data.endIndex-1
        for index in stride(from: data.endIndex-1, to: 0, by: -1) {
            if data[index].data.contains(end) {
                endIndex = index
                break
            }
        }
                
        var newData = data
        newData.removeSubrange((endIndex+1)...(newData.endIndex-1))
        
        let last = newData[newData.endIndex-1].data.filter {
            $0 <= end
        }
        newData[newData.endIndex-1] = Week(days: last)
        
        let lastDay = newData[0].firstDay()
        var currentDay = Calendar.current.date(byAdding: .month, value: -1, to: lastDay)!
        
        var newMonth = [Week]()
        
        while (!newMonth.contains(where: { w in
            w.data.contains(lastDay)
        })) {
            
            newMonth.append(Week(date: currentDay))
            
            currentDay = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDay)!
        }
        
        let first = newMonth[0].data.filter { $0 >= start }
        newMonth[0] = Week(days: first)
        
        newData.removeFirst()
        newData = newMonth + newData
        
        return newData
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
