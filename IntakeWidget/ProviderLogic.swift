//
//  ProviderLogic.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 1/17/22.
//

import Foundation
import SwiftUI

class ProviderLogic {
    static func filterDataByDay(day: Date, data: DrinkData) -> [Drink] {
        
        // Create a date formatter
        let dateFormatter = DateFormatter()
        
        // Only include the date not time
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // Filter by matching days
        var filtered = data.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: day) }
        
        // Filter by times
        filtered.sort { $0.date > $1.date }
        
        // Filter out disabled types
        return filtered.filter { $0.type.enabled }
    }
    
    static func getTypeAmountByWeek(type: DrinkType, date: Date, data: DrinkData) -> Double {
        // Get the filtered data for the day
        let time = ProviderLogic.filterDataByDay(day: date, data: data)
        
        // Filter by the drink type
        let drinks = time.filter { $0.type == type }
        
        // Add up all the amounts
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += Double(drink.amount)
        }
        
        return totalAmount
    }
    
    static func getTotalAmountByDay(date: Date, data: DrinkData) -> Double {
        
        var amount = 0.0
        
        // Get the amount for each drink type
        for type in data.drinkTypes {
            if type.enabled {
                amount += ProviderLogic.getTypeAmountByWeek(type: type, date: date, data: data)
            }
        }
        
        return amount
    }
    
    static func filterDataByWeek(week: [Date], data: DrinkData) -> [Drink] {
        
        // Create a date formatter to get dates in Month Day, Year format
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // Filter the drink data for each day
        let sunday = data.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[0]) }
        let monday = data.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[1]) }
        let tuesday = data.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[2]) }
        let wednesday = data.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[3]) }
        let thursday = data.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[4]) }
        let friday = data.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[5]) }
        let saturday = data.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[6]) }
        
        // Combine the arrays
        var weekData = sunday + monday + tuesday + wednesday + thursday + friday + saturday
        
        // Sort the array by date
        weekData.sort { $0.date > $1.date }
        
        return weekData
    }
    
    static func getTypeAmountByWeek(type: DrinkType, week: [Date], data: DrinkData) -> Double {
        
        // Get the drink data for the week
        let filtered = ProviderLogic.filterDataByWeek(week: week, data: data)
        
        // Filter by drink type
        let drinks = filtered.filter { $0.type == type }
        
        // Get the total amount
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += drink.amount
        }
        
        return totalAmount
    }
    
    static func getTotalAmountByWeek(week: [Date], data: DrinkData) -> Double {
        
        var amount = 0.0
        
        // Get the amount for each drink type
        for type in data.drinkTypes {
            if type.enabled {
                amount += ProviderLogic.getTypeAmountByWeek(type: type, week: week, data: data)
            }
        }
        
        return amount
    }
    
    static func getWeekRange(date: Date) -> [Date] {
        
        // Get the number for the day of the week (Sun = 1 ... Sat = 7)
        let dayNum = Calendar.current.dateComponents([.weekday], from: date).weekday
        
        // If there is a non-nil value...
        if dayNum != nil {
            
            // If it's Sunday...
            if dayNum == 1 {
                // Get the Saturday for that week
                let endDate = Calendar.current.date(byAdding: .day, value: 6, to: date)!
                
                return [date, endDate]
                
                // If it's a day from Monday to Friday...
            } else if dayNum! > 1 && dayNum! < 7 {
                
                // Get the difference between the current day and the Sunday and Saturday of that week
                let startDiff = -1 + dayNum!
                let endDiff = 7 - dayNum!
                
                // Get the exact dates
                let startDate = Calendar.current.date(byAdding: .day, value: -startDiff, to: date)!
                let endDate = Calendar.current.date(byAdding: .day, value: endDiff, to: date)!
                
                return [startDate, endDate]
                
                // If it's Saturday...
            } else if dayNum == 7 {
                // Get the Sunday for that week
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: date)!
                
                return [startDate, date]
            } else {
                return [Date]()
            }
        } else {
            return [Date]()
        }
    }
    
    static func getDaysInWeek(date: Date) -> [Date] {
        // Get the week range
        let weekRange = ProviderLogic.getWeekRange(date: date)
        
        // If the array isn't empty...
        if weekRange.count == 2 {
            
            // Get the exact day for each day of the week
            let sunday = weekRange[0]
            let monday = Calendar.current.date(byAdding: .day, value: 1, to: sunday)!
            let tuesday = Calendar.current.date(byAdding: .day, value: 2, to: sunday)!
            let wednesday = Calendar.current.date(byAdding: .day, value: 3, to: sunday)!
            let thursday = Calendar.current.date(byAdding: .day, value: 4, to: sunday)!
            let friday = Calendar.current.date(byAdding: .day, value: 5, to: sunday)!
            let saturday = weekRange[1]
            
            return [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
        }
        
        // Else return an empty array
        return [Date]()
    }
}
