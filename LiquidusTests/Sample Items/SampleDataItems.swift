//
//  SampleDataItems.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/4/22.
//

import Foundation
@testable import Liquidus

class SampleDataItems {
    
    static func day(_ day: Date) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()

        // Create an empty date array
        var dates = [Date]()
        
        // Append dates for each hour in the day
        for num in 0...23 {
            if let date = Calendar.current.date(bySettingHour: num, minute: 0, second: 0, of: day) {
                dates.append(date)
            }
        }
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex
        var typeIndex = 0

        // Loop through dates array
        for index in 0..<dates.count {
            
            // Append drink based on index and typeIndex
            items.append(DataItem(drinks: [Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.day[index], date: dates[index])], type: types[typeIndex % 4], date: dates[index]))
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return items array
        return items
    }
    
    static func week(_ week: [Date]) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through week array
        for index in 0..<week.count {
            
            // Append drink based on index and typeIndex
            items.append(DataItem(drinks: [Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.week[index], date: week[index])], type: types[typeIndex % 4], date: week[index]))
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return items array
        return items
    }
    
    static func month(_ month: [Date]) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through dates array
        for index in 0..<month.count {
            
            // Append drink based on index and typeIndex
            items.append(DataItem(drinks: [Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.month[index], date: month[index])], type: types[typeIndex % 4], date: month[index]))

            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return items array
        return items
    }
    
    static func halfYear(_ halfYear: [[Date]]) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex and amountIndex
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through weeks in half year
        for week in halfYear {
            // Empty drinks array
            var drinks = [Drink]()
            
            // Loop through days in week
            for day in week {
                
                // Append drink based on typeIndex and amountIndex
                drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.week[amountIndex % 7], date: day))
                
                // Increment indices
                typeIndex += 1
                amountIndex += 1
            }
            
            // Append DataItem
            items.append(DataItem(drinks: drinks, type: Constants.totalType, date: week.first!))
        }
        
        // Return items array
        return items
    }
    
    static func year(_ year: [[Date]]) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex and amountIndex
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through months in year
        for month in year {
            
            // Empty drinks array
            var drinks = [Drink]()
            
            // Loop through days in month
            for day in month {
                
                // Append drink based on typeIndex and amountIndex
                drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.month[amountIndex], date: day))
                
                // Increment indices
                typeIndex += 1
                amountIndex += 1
            }
            
            // Append DataItem
            items.append(DataItem(drinks: drinks, type: Constants.totalType, date: month.first!))
            
            // Reset amountIndex
            amountIndex = 0
        }
        
        // Return items array
        return items
    }
}
