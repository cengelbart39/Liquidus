//
//  SampleDrinks.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/19/22.
//

import Foundation
import CoreData
@testable import Liquidus

/**
 A container class for static methods that generate a set of `Drink`s for objects conformant to `DatesProtocol`
 */
class SampleDrinks {
    /**
     Gets a sample set of drinks with a drink per hour in the day
     - Parameters:
        - day: The `Day` to create `Drink`s for
        - context: A view context to create the `Drink`s
     - Returns: A sample set of `DrinkType`s with appended `Drink`(s)
     */
    static func day(_ day: Day, context: NSManagedObjectContext) -> [DrinkType] {
        
        // Get hours
        let hours = day.getHours()
        
        // Get default drink types
        let types = SampleDrinkTypes.defaultTypes(context)
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through dates array
        for index in 0..<hours.count {
            
            // Append drink based on index
            let drink = Drink(context: context)
            drink.id = UUID()
            drink.type = types[typeIndex % 4]
            drink.amount = SampleDrinkAmounts.day[index]
            drink.date = hours[index].data
            
            types[typeIndex % 4].addToDrinks(drink)
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return drinks array
        return types
    
    }
    
    /**
     Gets a sample set of drinks with a drink per day in the week
     - Parameters:
        - week: The `Week` to create `Drink`s for
        - context: A view context to create the `Drink`s
     - Returns: A sample set of `DrinkType`s with appended `Drink`(s)
     */
    static func week(_ week: Week, context: NSManagedObjectContext) -> [DrinkType] {
        // Get default drink types
        let types = SampleDrinkTypes.defaultTypes(context)
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through dates array
        for index in 0..<week.data.count {
            
            // Append drink based on index
            let drink = Drink(context: context)
            drink.id = UUID()
            drink.type = types[typeIndex % 4]
            drink.amount = SampleDrinkAmounts.week[index]
            drink.date = week.data[index]
            
            types[typeIndex % 4].addToDrinks(drink)
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        return types
    }
    
    /**
     Gets a sample set of drinks with a drink per day in the week with an additional custom `DrinkType`
     - Parameters:
        - week: The `Week` to create `Drink`s for
        - context: A view context to create the `Drink`s
     - Returns: A sample set of `DrinkType`s with appended `Drink`(s)
     */
    static func weekCustom(_ week: Week, context: NSManagedObjectContext) -> [DrinkType] {

        // Get default drink types
        let types = SampleDrinkTypes.allTypes(context)
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through week array
        for index in 0..<week.data.count {
            
            // Append drink based on index
            let drink = Drink(context: context)
            drink.id = UUID()
            drink.type = types[typeIndex % 5]
            drink.amount = SampleDrinkAmounts.week[index]
            drink.date = week.data[index]
            
            types[typeIndex % 5].addToDrinks(drink)
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        return types
    }
    
    /**
     Gets a sample set of drinks with a drink per day in the month
     - Parameters:
        - month: The `Month` to create `Drink`s for
        - context: A view context to create the `Drink`s
     - Returns: A sample set of `DrinkType`s with appended `Drink`(s)
     */
    static func month(_ month: Month, context: NSManagedObjectContext) -> [DrinkType] {

        // Get default drink types
        let types = SampleDrinkTypes.defaultTypes(context)
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through month array
        for index in 0..<month.data.count {
            
            // Append drink based on index
            let drink = Drink(context: context)
            drink.id = UUID()
            drink.type = types[typeIndex % 4]
            drink.amount = SampleDrinkAmounts.month[index]
            drink.date = month.data[index]
            
            types[typeIndex % 4].addToDrinks(drink)
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        return types
    }
    
    /**
     Gets a sample set of drinks with a drink for every day in every week in a `HalfYear`
     - Parameters:
        - halfYear: The `HalfYear` to create `Drink`s for
        - context: A view context to create the `Drink`s
     - Returns: A sample set of `DrinkType`s with appended `Drink`(s)
     */
    static func halfYear(_ halfYear: HalfYear, context: NSManagedObjectContext) -> [DrinkType] {

        // Get default drink types
        let types = SampleDrinkTypes.defaultTypes(context)
        
        // Create typeIndex and amountIndex
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through week in halfYear
        for week in halfYear.data {
            
            // Loop through day in week
            for day in week.data {
                
                let drink = Drink(context: context)
                drink.id = UUID()
                drink.type = types[typeIndex % 4]
                drink.amount = SampleDrinkAmounts.week[amountIndex % 7]
                drink.date = day
                
                types[typeIndex % 4].addToDrinks(drink)
                
                // Increment indices
                typeIndex += 1
                amountIndex += 1
            }
        }
        
        // Return drinks array
        return types
    }
    
    /**
     Gets a sample set of drinks with a drink for every day in every month in `Year`
     - Parameters:
        - year: The `Year` to create `Drink`s for
        - context: A view context to create the `Drink`s
     - Returns: A sample set of `DrinkType`s with appended `Drink`(s)
     */
    static func year(_ year: Year, context: NSManagedObjectContext) -> [DrinkType] {

        // Get default drink types
        let types = SampleDrinkTypes.defaultTypes(context)
        
        // Create typeIndex and amountIndex
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through months in year
        for month in year.data {
            
            // Loop through days in month
            for day in month.data {
                
                let drink = Drink(context: context)
                drink.id = UUID()
                drink.type = types[typeIndex % 4]
                drink.amount = SampleDrinkAmounts.month[amountIndex]
                drink.date = day
                
                types[typeIndex % 4].addToDrinks(drink)
                
                // Increment indices
                typeIndex += 1
                amountIndex += 1
            }
            
            // Reset amountIndex
            amountIndex = 0
        }
        
        // Return drinks array
        return types
    }
}
