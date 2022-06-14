//
//  SampleDataItems.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/4/22.
//

import Foundation
import CoreData
@testable import Liquidus

/**
 A container class for static methods that generate a set of `DataItem`s for objects conformant to `DatesProtocol`
 */
class SampleDataItems {
    
    /**
     Gets a sample set of `DataItem`s with a `DataItem` for every `Hour` in the `Day`
     - Parameters:
        - day: The `Day` to create `DataItem`s for
        - context: A view context used to create `DrinkType`s and `Drink`s
     - Returns: A sample set of `DataItem`s
     */
    static func day(_ day: Day, context: NSManagedObjectContext) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()

        // Get hours
        let hours = day.getHours()
        
        // Get default drink types
        let types = SampleDrinkTypes.defaultTypes(context)
        
        // Create typeIndex
        var typeIndex = 0

        // Loop through dates array
        for index in 0..<hours.count {
            
            let drink = Drink(context: context)
            drink.id = UUID()
            drink.amount = SampleDrinkAmounts.day[index]
            drink.date = hours[index].data
            drink.type = types[typeIndex % 4]
            
            types[typeIndex % 4].addToDrinks(drink)
            
            items.append(DataItem(drinks: [drink], type: nil, total: true, date: hours[index].data))
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return items array
        return items
    }
    
    /**
     Gets a sample set of `DataItem`s with a `DataItem` for every `Day` in the `Week`
     - Parameters:
        - week: The `Week` to create `DataItem`s for
        - context: A view context used to create `DrinkType`s and `Drink`s
     - Returns: A sample set of `DataItem`s
     */
    static func week(_ week: Week, context: NSManagedObjectContext) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()
        
        // Get default drink types
        let types = SampleDrinkTypes.defaultTypes(context)
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through week array
        for index in 0..<week.data.count {
            
            let drink = Drink(context: context)
            drink.id = UUID()
            drink.amount = SampleDrinkAmounts.week[index]
            drink.date = week.data[index]
            drink.type = types[typeIndex % 4]
            
            types[typeIndex % 4].addToDrinks(drink)
            
            items.append(DataItem(drinks: [drink], type: nil, total: true, date: week.data[index]))
            
            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return items array
        return items
    }
    
    /**
     Gets a sample set of `DataItem`s with a `DataItem` for every `Day` in the `Month`
     - Parameters:
        - month: The `Month` to create `DataItem`s for
        - context: A view context used to create `DrinkType`s and `Drink`s
     - Returns: A sample set of `DataItem`s
     */
    static func month(_ month: Month, context: NSManagedObjectContext) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()
        
        // Get default drink types
        let types = SampleDrinkTypes.defaultTypes(context)
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through dates array
        for index in 0..<month.data.count {
            
            let drink = Drink(context: context)
            drink.id = UUID()
            drink.amount = SampleDrinkAmounts.month[index]
            drink.date = month.data[index]
            drink.type = types[typeIndex % 4]
            
            types[typeIndex % 4].addToDrinks(drink)
            
            items.append(DataItem(drinks: [drink], type: nil, total: true, date: month.data[index]))

            // Increment typeIndex
            typeIndex += 1
        }
        
        // Return items array
        return items
    }
    
    /**
     Gets a sample set of `DataItem`s with a single `DataItem` for every `Week` in the `HalfYear`
     - Parameters:
        - halfYear: The `HalfYear` to create `DataItem`s for
        - context: A view context used to create `DrinkType`s and `Drink`s
     - Returns: A sample set of `DataItem`s
     */
    static func halfYear(_ halfYear: HalfYear, context: NSManagedObjectContext) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()
        
        // Get default drink types
        let types = SampleDrinkTypes.defaultTypes(context)
        
        // Create typeIndex and amountIndex
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through weeks in half year
        for week in halfYear.data {
            // Empty drinks array
            var drinks = [Drink]()
            
            // Loop through days in week
            for day in week.data {
                
                let drink = Drink(context: context)
                drink.id = UUID()
                drink.amount = SampleDrinkAmounts.week[amountIndex % 7]
                drink.date = day
                drink.type = types[typeIndex % 4]
                
                types[typeIndex % 4].addToDrinks(drink)
                                
                // Append drink based on typeIndex and amountIndex
                drinks.append(drink)
                
                // Increment indices
                typeIndex += 1
                amountIndex += 1
            }
            
            // Append DataItem
            items.append(DataItem(drinks: drinks, type: nil, total: true, date: week.firstDay()))
        }
        
        // Return items array
        return items
    }
    
    /**
     Gets a sample set of `DataItem`s with a single `DataItem` for every `Month` in the `Year`
     - Parameters:
        - year: The `Year` to create `DataItem`s for
        - context: A view context used to create `DrinkType`s and `Drink`s
     - Returns: A sample set of `DataItem`s
     */
    static func year(_ year: Year, context: NSManagedObjectContext) -> [DataItem] {
        // Empty items array
        var items = [DataItem]()
        
        // Get default drink types
        let types = SampleDrinkTypes.defaultTypes(context)
        
        // Create typeIndex and amountIndex
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through months in year
        for month in year.data {
            
            // Empty drinks array
            var drinks = [Drink]()
            
            // Loop through days in month
            for day in month.data {
                
                let drink = Drink(context: context)
                drink.id = UUID()
                drink.amount = SampleDrinkAmounts.month[amountIndex]
                drink.date = day
                drink.type = types[typeIndex % 4]
                
                types[typeIndex % 4].addToDrinks(drink)
                                
                // Append drink based on typeIndex and amountIndex
                drinks.append(drink)
                
                // Increment indices
                typeIndex += 1
                amountIndex += 1
            }
            
            // Append DataItem
            items.append(DataItem(drinks: drinks, type: nil, total: true, date: month.firstDay()))
                        
            // Reset amountIndex
            amountIndex = 0
        }
        
        // Return items array
        return items
    }
}
