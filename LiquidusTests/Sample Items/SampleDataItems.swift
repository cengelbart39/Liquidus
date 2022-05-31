//
//  SampleDataItems.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/4/22.
//

import Foundation
@testable import Liquidus

/**
 A container class for static methods that generate a set of `DataItem`s for objects conformant to `DatesProtocol`
 */
class SampleDataItems {
    
    /**
     Gets a sample set of `DataItem`s with a `DataItem` for every `Hour` in the `Day`
     - Parameter day: The `Day` to create `DataItem`s for
     - Returns: A sample set of `DataItem`s
     */
    static func day(_ day: Day) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()

        // Get hours
        let hours = day.getHours()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex
        var typeIndex = 0

        // Loop through dates array
        for index in 0..<hours.count {
            
            // Append drink based on index and typeIndex
            items.append(DataItem(drinks: [Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.day[index], date: hours[index].data)], type: types[typeIndex % 4], date: hours[index].data))
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return items array
        return items
    }
    
    /**
     Gets a sample set of `DataItem`s with a `DataItem` for every `Day` in the `Week`
     - Parameter day: The `Week` to create `DataItem`s for
     - Returns: A sample set of `DataItem`s
     */
    static func week(_ week: Week) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through week array
        for index in 0..<week.data.count {
            
            // Append drink based on index and typeIndex
            items.append(DataItem(drinks: [Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.week[index], date: week.data[index])], type: types[typeIndex % 4], date: week.data[index]))
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return items array
        return items
    }
    
    /**
     Gets a sample set of `DataItem`s with a `DataItem` for every `Day` in the `Month`
     - Parameter day: The `Month` to create `DataItem`s for
     - Returns: A sample set of `DataItem`s
     */
    static func month(_ month: Month) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through dates array
        for index in 0..<month.data.count {
            
            // Append drink based on index and typeIndex
            items.append(DataItem(drinks: [Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.month[index], date: month.data[index])], type: types[typeIndex % 4], date: month.data[index]))

            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return items array
        return items
    }
    
    /**
     Gets a sample set of `DataItem`s with a single `DataItem` for every `Week` in the `HalfYear`
     - Parameter day: The `HalfYear` to create `DataItem`s for
     - Returns: A sample set of `DataItem`s
     */
    static func halfYear(_ halfYear: HalfYear) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex and amountIndex
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through weeks in half year
        for week in halfYear.data {
            // Empty drinks array
            var drinks = [Drink]()
            
            // Loop through days in week
            for day in week.data {
                
                // Append drink based on typeIndex and amountIndex
                drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.week[amountIndex % 7], date: day))
                
                // Increment indices
                typeIndex += 1
                amountIndex += 1
            }
            
            // Append DataItem
            items.append(DataItem(drinks: drinks, type: Constants.totalType, date: week.firstDay()))
        }
        
        // Return items array
        return items
    }
    
    /**
     Gets a sample set of `DataItem`s with a single `DataItem` for every `Month` in the `Year`
     - Parameter day: The `Year` to create `DataItem`s for
     - Returns: A sample set of `DataItem`s
     */
    static func year(_ year: Year) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex and amountIndex
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through months in year
        for month in year.data {
            
            // Empty drinks array
            var drinks = [Drink]()
            
            // Loop through days in month
            for day in month.data {
                
                // Append drink based on typeIndex and amountIndex
                drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.month[amountIndex], date: day))
                
                // Increment indices
                typeIndex += 1
                amountIndex += 1
            }
            
            // Append DataItem
            items.append(DataItem(drinks: drinks, type: Constants.totalType, date: month.firstDay()))
            
            // Reset amountIndex
            amountIndex = 0
        }
        
        // Return items array
        return items
    }
}
