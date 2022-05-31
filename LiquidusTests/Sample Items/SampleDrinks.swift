//
//  SampleDrinks.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/19/22.
//

import Foundation
@testable import Liquidus

/**
 A container class for static methods that generate a set of `Drink`s for objects conformant to `DatesProtocol`
 */
class SampleDrinks {
    /**
     Gets a sample set of drinks with a drink per hour in the day
     - Parameter day: The `Day` to create `Drink`s for
     - Returns: A sample set of `Drink`s
     */
    static func day(_ day: Day) -> [Drink] {
        // Empty drink array
        var drinks = [Drink]()
        
        // Get hours
        let hours = day.getHours()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through dates array
        for index in 0..<hours.count {
            
            // Append drink based on index
            drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.day[index], date: hours[index].data))
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return drinks array
        return drinks
    
    }
    
    /**
     Gets a sample set of drinks with a drink per day in the week
     - Parameter week: The `Week` to create `Drink`s for
     - Returns: A sample set of `Drink`s
     */
    static func week(_ week: Week) -> [Drink] {
        // Empty drink array
        var drinks = [Drink]()
        
        // Get default drink types
        let drinkTypes = DrinkType.getDefault()
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through week array
        for index in 0..<week.data.count {
            
            // Append drink based on index
            drinks.append(Drink(type: drinkTypes[typeIndex % 4], amount: SampleDrinkAmounts.week[index], date: week.data[index]))
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return drinks array
        return drinks
    }
    
    /**
     Gets a sample set of drinks with a drink per day in the week
     - Parameters:
        - week: The `Week` to create `Drink`s for
        - type: Adds a `DrinkType` along with the default ones
     - Returns: A sample set of `Drink`s
     */
    static func week(_ week: Week, type: DrinkType) -> [Drink] {
        // Empty drink array
        var drinks = [Drink]()
        
        // Get default drink types and add passed in type
        let drinkTypes = DrinkType.getDefault() + [type]
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through week array
        for index in 0..<week.data.count {
            
            // Append drink based on index
            drinks.append(Drink(type: drinkTypes[typeIndex % 5], amount: SampleDrinkAmounts.week[index], date: week.data[index]))
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return drinks array
        return drinks
    }
    
    /**
     Gets a sample set of drinks with a drink per day in the month
     - Parameter month: The `Month` to create `Drink`s for
     - Returns: A sample set of `Drink`s
     */
    static func month(_ month: Month) -> [Drink] {
        // Empty drink array
        var drinks = [Drink]()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through month array
        for index in 0..<month.data.count {
            
            // Append drink based on index
            drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.month[index], date: month.data[index]))
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return drinks array
        return drinks
    }
    
    /**
     Gets a sample set of drinks with a drink for every day in every week in the `HalfYear`
     - Parameter halfYear: The `halfYear` to create `Drink`s for
     - Returns: A sample set of `Drink`s
     */
    static func halfYear(_ halfYear: HalfYear) -> [Drink] {
        // Empty drink array
        var drinks = [Drink]()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex and amountIndex
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through week in halfYear
        for week in halfYear.data {
            
            // Loop through day in week
            for day in week.data {
                
                // Append drink based on indices
                drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.week[amountIndex % 7], date: day))
                
                // Increment indices
                typeIndex += 1
                amountIndex += 1
            }
        }
        
        // Return drinks array
        return drinks
    }
    
    /**
     Gets a sample set of drinks with a drink for every day in every month in the `Year`
     - Parameter year: The `year` to create `Drink`s for
     - Returns: A sample set of `Drink`s
     */
    static func year(_ year: Year) -> [Drink] {
        // Empty drink array
        var drinks = [Drink]()
        
        // Get default drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex and amountIndex
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through months in year
        for month in year.data {
            
            // Loop through days in month
            for day in month.data {
                
                // Append drink based on indices
                drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.month[amountIndex], date: day))
                
                // Increment indices
                typeIndex += 1
                amountIndex += 1
            }
            
            // Reset amountIndex
            amountIndex = 0
        }
        
        // Return drinks array
        return drinks
    }
}
