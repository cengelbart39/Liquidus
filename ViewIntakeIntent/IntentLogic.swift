//
//  IntentLogic.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 1/22/22.
//

import Foundation

class IntentLogic {
    
    /**
     Get the `Drink`s consumed during the given `Date`
     - Parameters:
        - day: The `Date` to filter by
        - data: The User's Data
     - Returns: The `Drink`s consumed during `day`
     */
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
    
    /**
     Get the total amount of `Drink`s consumed of a given `DrinkType` during a given `Date`
     - Parameters:
        - type: The `DrinkType` to filter for
        - date: The `Date` to filter for
        - data: The User's Data
     - Returns: The `Drink`s consumed of `type` during `day`
     */
    static func getTypeAmountByDay(type: DrinkType, date: Date, data: DrinkData) -> Double {
        // Get the filtered data for the day
        let time = IntentLogic.filterDataByDay(day: date, data: data)
        
        // Filter by the drink type
        let drinks = time.filter { $0.type == type }
        
        // Add up all the amounts
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += Double(drink.amount)
        }
        
        return totalAmount
    }
    
    /**
     Get the total amount of `Drink`s consumed during the given `Date`
     - Parameters:
        - date: The `Date` to get the total amount for
        - data: The User's Data
     - Returns: The total amount of `Drink`s consumed during `date`
    */
    static func getTotalAmountByDay(date: Date, data: DrinkData) -> Double {
        
        var amount = 0.0
        
        // Get the amount for each drink type
        for type in data.drinkTypes {
            if type.enabled {
                amount += IntentLogic.getTypeAmountByDay(type: type, date: date, data: data)
            }
        }
        
        return amount
    }
    
    /**
     Get the total percent of the user's progress towards their daily goal
     - Parameters:
        - date: The date to get the percent for
        - data: The User's Data
     - Returns: The total percent of the user's progress towards their daily goal
     */
    static func getTotalPercentByDay(date: Date, data: DrinkData) -> Double {
        
        // Get total amount
        let totalAmount = IntentLogic.getTotalAmountByDay(date: date, data: data)
        
        // Get percentage
        let percent = totalAmount / data.dailyGoal
        
        return percent
    }
}
