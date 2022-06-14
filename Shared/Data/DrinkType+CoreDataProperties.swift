//
//  DrinkType+CoreDataProperties.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 5/31/22.
//
//

import Foundation
import CoreData
import UIKit

extension DrinkType {

    /**
     Get a `DrinkType` `FetchRequest`
     - Returns: A `FetchRequest<DrinkType>`
     */
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrinkType> {
        return NSFetchRequest<DrinkType>(entityName: "DrinkType")
    }

    /// The id of the `DrinkType`
    @NSManaged public var id: UUID?
    
    /// A designated integer used for sorting and identificaton
    @NSManaged public var order: Int
    
    /// The name of the `DrinkType`
    @NSManaged public var name: String
    
    /// Whether or not the `DrinkType` is included by default
    @NSManaged public var isDefault: Bool
    
    /// Whether or not the `DrinkType` is enabled; applies only to Default Drink Types
    @NSManaged public var enabled: Bool
    
    /// Whether or not the color of the `DrinkType` has been changed; always `true` for custom types; defaults to `false` for default types
    @NSManaged public var colorChanged: Bool
    
    /// The data of the associated color
    @NSManaged public var color: Data?
    
    /// The `Drink`s consumed of this type; `nil` if there aren't any
    @NSManaged public var drinks: NSSet?
}

// MARK: - Generated accessors for drink
extension DrinkType {

    /**
     Add a `Drink` to the `drinks` property
     - Parameter value: The `Drink` to be added
     */
    @objc(addDrinksObject:)
    @NSManaged public func addToDrinks(_ value: Drink)

    /**
     Deletes a `Drink` from the `drinks` property
     - Parameter value: The `Drink` to be deleted
     */
    @objc(removeDrinksObject:)
    @NSManaged public func removeFromDrinks(_ value: Drink)

    /**
     Add multiple `Drink`s to the `drinks` property
     - Parameter values: The `Drink`(s) to be added
     */
    @objc(addDrinks:)
    @NSManaged public func addToDrinks(_ values: NSSet)

    /**
     Remove multiple `Drink`s from the `drinks` property
     - Parameter values: The `Drink`(s) to be removed
     */
    @objc(removeDrinks:)
    @NSManaged public func removeFromDrinks(_ values: NSSet)

}

// MARK: - Identifiable
extension DrinkType : Identifiable {

}

// MARK: - Type Measurement Methods
extension DrinkType {
    
    /**
     Return the total amount of all `Drink`s consumed of this type
     - Returns: The total amount consumed for this type
     */
    func getTypeAmount() -> Double {
        var amount = 0.0
        
        if let drinks = self.drinks?.allObjects as? [Drink] {
            for drink in drinks {
                amount += drink.amount
            }
        }
        
        return amount
    }
    
    /**
     Get the percent of all `Drink`s consumed of this type over the user's daily goal
     - Parameter goal: The user's daily goal
     - Returns: The percentage of `Drink`s consumed over the user's goal
     */
    func getTypePercent(goal: Double) -> Double {
        
        let typeAmount = self.getTypeAmount()
        
        return typeAmount/goal
    }
    
    /**
     Get the average of the amount of`Drink`s consumed across the past 3 months, if it has passed since the first `Drink` logged
     - Parameter startDate: Used to determine if 3 months have passed from the user's current date
     - Returns: The type average over the past 3 months; `nil` if no `Drink`s exist or 3 months haven't passed since the first `Drink` has been logged
     */
    func getTypeAverage(startDate: Date) -> Double? {
        // Get total based on passed in type
        let total = self.getTypeAmount()
        
        // Get all drinks based on passed in type
        if let drinks = self.drinks?.allObjects as? [Drink] {
            // Find the minumum date from drinks
            var minDate = Date()
            for drink in drinks {
                if drink.date < minDate {
                    minDate = drink.date
                }
            }
            
            // Get the difference in months between minDate and startDate
            let monthDifference = Calendar.current.dateComponents([.month], from: minDate, to: startDate)
            
            // Get the date that is three months earlier than startDate
            if let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: startDate) {
                
                // Get the components in days for threeMonthsAgo
                let threeMonths = Calendar.current.dateComponents([.day], from: threeMonthsAgo, to: .now)
                
                // Get the day count and mounth count
                if let threeDiff = threeMonths.day, let monthDiff = monthDifference.month {
                    
                    // If three or more months have data return the average
                    if monthDiff >= 3 {
                        return floor(total/Double(threeDiff))
                        
                    // If not return nil
                    } else if monthDiff < 3 {
                        return nil
                    }
                }
            }
            
            return 0.0
        }
        
        return nil
    }
}

// MARK: - Hour Methods
extension DrinkType {
    
    /**
     Gets `Drink`s consumed during the given `Hour`
     - Parameter hour: The `Hour` to filter by
     - Returns: A `Drink` array for all `Drink`s in `hour`
     */
    func filterDataByHour(hour: Hour) -> [Drink] {
        
        var output = [Drink]()
        
        if let drinks = self.drinks?.allObjects as? [Drink] {
            output += drinks.filter {
                Calendar.current.compare($0.date, to: hour.data, toGranularity: .hour) == .orderedSame && Calendar.current.compare($0.date, to: hour.data, toGranularity: .day) == .orderedSame && Calendar.current.compare($0.date, to: hour.data, toGranularity: .month) == .orderedSame && Calendar.current.compare($0.date, to: hour.data, toGranularity: .year) == .orderedSame
            }
        }
        
        return output
    }
    
    /**
     Get the total amount consumed of a given `DrinkType` and consumed during the given `Hour`
     - Parameter hour: The `Hour` to get the amount for
     - Returns: The overall amount of the `Drink`s of this type consumed during `hour`
     */
    func getTypeAmountByHour(hour: Hour) -> Double {
        let drinks = self.filterDataByHour(hour: hour)
        
        var amount = 0.0
        
        for drink in drinks {
            amount += drink.amount
        }
        
        return amount
    }
}


// MARK: - Day Methods
extension DrinkType {
    
    /**
     Filter all `Drink`s consumed during the given `Day`
     - Parameter day: The `Day` to filter by
     - Returns: The `Drink`s consumed during `day`
     */
    func filterDataByDay(day: Day) -> [Drink] {
        var output = [Drink]()
        
        if let drinks = self.drinks?.allObjects as? [Drink] {
            output = drinks.filter {
                Calendar.current.compare($0.date, to: day.data, toGranularity: .day) == .orderedSame && Calendar.current.compare($0.date, to: day.data, toGranularity: .month) == .orderedSame && Calendar.current.compare($0.date, to: day.data, toGranularity: .year) == .orderedSame
            }
        }
        
        return output
    }
    
    /**
     Get the total amount of `Drink`s consumed of this type during the given `Day`
     - Parameter day: The `Day` to get the amount for
     - Returns: The total amount of `Drink`s consumed of this type during `day`
     */
    func getTypeAmountByDay(day: Day) -> Double {
        let drinks = self.filterDataByDay(day: day)
        
        var amount = 0.0
        
        for drink in drinks {
            amount += drink.amount
        }
        
        return amount
    }
    
    /**
     Get the total percent of the amount of `Drink`s consumed for this type during a given `Day` over the user's daily goal
     - Parameters:
        - day: The `Day` to get the percentage for
        - goal: The user's goal
     - Returns: The total percent of the amount of `Drink`s consumed for this type during `day` over the user's daily goal
     */
    func getTypePercentByDay(day: Day, goal: Double) -> Double {
        let typeAmount = self.getTypeAmountByDay(day: day)
        
        return typeAmount/goal
    }
    
    /**
     For a given `Day`, return `DataItem`s for each `Hour` in that `Day` of this type
     - Parameter day: The `Day` to get `DataItem`s for
     - Returns: `DataItem`s for each `Hour` in `day` of this type
     */
    func getDataItemsByDay(day: Day) -> [DataItem] {
        var dataItems = [DataItem]()
        
        let hours = day.getHours()
        
        // Loop through hour in dates
        for hour in hours {
            
            // Get the drinks based on the presense of the Total Type
            let drinks = self.filterDataByHour(hour: hour)
            
            // Append the DataItem, using nil for drinks if drink array is empty
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: self, total: false, date: hour.data))
        }
        
        return dataItems
    }
}

// MARK: - Week Methods
extension DrinkType {
    /**
     Get the `Drink`s of this type consumed during the given `Week`
     - Parameter week: The `Week` to filter by
     - Returns: The `Drink`s of this type consumed during `week`
     */
    func filterDataByWeek(week: Week) -> [Drink] {
        
        var drinks = [Drink]()
        
        for day in week.data {
            drinks += self.filterDataByDay(day: Day(date: day))
        }
        
        return drinks
        
    }
    
    /**
     Get the total amount of `Drink`s consumed of this type during a given `Week`
     - Parameter week: The `Week` to get the total amount for
     - Returns: The total amount of `Drink`s consumed of this type during `week`
     */
    func getTypeAmountByWeek(week: Week) -> Double {
        // Get the drink data for the week
        let drinks = self.filterDataByWeek(week: week)
        
        // Get the total amount
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += drink.amount
        }
        
        return totalAmount
    }
    
    /**
     For a given `Week`, return `DataItem`s for each `Date` in that `Week` of this type
     - Parameter week: The `Week` to get `DataItem`s for
     - Returns: `DataItem`s for each `Date` in `week` and of this type
     */
    func getDataItemsByWeek(week: Week) -> [DataItem] {
        var dataItems = [DataItem]()
                
        // Loop through hour in dates
        for day in week.data {
            
            // Get the drinks based on the presense of the Total Type
            let drinks = self.filterDataByDay(day: Day(date: day))
            
            // Append the DataItem, using nil for drinks if drink array is empty
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: self, total: false, date: day))
        }
        
        return dataItems
    }

}

// MARK: - Month Methods
extension DrinkType {
    /**
     Get the `Drink`s that were consumed during a given `Month` of this type
     - Parameter month: The `Month` to filter by
     - Returns: The `Drink`s that were consumed during `month` of this type
     */
    func filterDataByMonth(month: Month) -> [Drink] {
        
        var output = [Drink]()
        
        if let drinks = self.drinks?.allObjects as? [Drink] {
            output = drinks.filter {
                Calendar.current.compare(month.firstDay(), to: $0.date, toGranularity: .month) == .orderedSame && Calendar.current.compare(month.firstDay(), to: $0.date, toGranularity: .year) == .orderedSame
            }
        }
        
        return output
    }
    
    /**
     Get the total amount of `Drink`s consumed during the given `Month` and of this type
     - Parameter month: The `Month` to get the type amount for
     - Returns: The total amount of `Drink`s consumed during `month` and of this type
     */
    func getTypeAmountByMonth(month: Month) -> Double {
        // Get the drinks for the given type and month
        let drinks = self.filterDataByMonth(month: month)
        
        // Track the total amount consumed
        var amount = 0.0
        
        // Loop through drinks and add to amount
        for drink in drinks {
            amount += drink.amount
        }
        
        return amount
    }
    
    /**
     For a given `Month`, return `DataItem`s for each `Date` in that `Month` of this type
     - Parameter month: The `Month` to get `DataItem`s for
     - Returns: `DataItem`s for each `Date` in `month` and of this type
     */
    func getDataItemsByMonth(month: Month) -> [DataItem] {
        var dataItems = [DataItem]()
                
        // Loop through hour in dates
        for day in month.data {
            
            // Get the drinks based on the presense of the Total Type
            let drinks = self.filterDataByDay(day: Day(date: day))
            
            // Append the DataItem, using nil for drinks if drink array is empty
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: self, total: false, date: day))
        }
        
        return dataItems
    }
}

// MARK: - Half Year Methods
extension DrinkType {
    /**
     Get the `Drink`s that were consumed during a given `HalfYear` of this type
     - Parameter halfYear: The `HalfYear` to filter by
     - Returns: The `Drink`s that were consumed during `halfYear` of this type
     */
    func filterDataByHalfYear(halfYear: HalfYear) -> [Drink] {
        // Empty drink array
        var drinks = [Drink]()
        
        // Loop through each week and append the drinks that are in each month
        for week in halfYear.data {
            for drink in self.filterDataByWeek(week: week) {
                drinks.append(drink)
            }
        }
        
        // Sort drinks by date
        drinks.sort { $0.date  < $1.date }
        
        return drinks
    }
    
    /**
     Get the total amount of `Drink`s consumed during the given `HalfYear` and of this type
     - Parameter halfYear: The `HalfYear` to get the type amount for
     - Returns: The total amount of `Drink`s consumed during `halfYear` and of this type
     */
    func getTypeAmountByHalfYear(halfYear: HalfYear) -> Double {
        // Get the drinks
        let drinks = self.filterDataByHalfYear(halfYear: halfYear)
        
        // Get the total amount
        var amount = 0.0
        
        for drink in drinks {
            amount += drink.amount
        }
        
        return amount
    }
    
    /**
     For a given `HalfYear`, return `DataItem`s for each `Week` in that `HalfYear` of this type
     - Parameter halfYear: The `HalfYear` to get `DataItem`s for
     - Returns: `DataItem`s for each `Week` in `HalfYear` and of this type
     */
    func getDataItemsByHalfYear(halfYear: HalfYear) -> [DataItem] {
        var dataItems = [DataItem]()
                
        // Loop through hour in dates
        for week in halfYear.data {
            
            // Get the drinks based on the presense of the Total Type
            let drinks = self.filterDataByWeek(week: week)
            
            // Append the DataItem, using nil for drinks if drink array is empty
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: self, total: false, date: week.firstDay()))
        }
        
        return dataItems
    }
}

// MARK: - Year Methods
extension DrinkType {
    /**
     Get the `Drink`s that were consumed during a given `Year` of this type
     - Parameter year: The `Year` to filter by
     - Returns: The `Drink`s that were consumed during `year` of this type
     */
    func filterDataByYear(year: Year) -> [Drink] {
        // Create empty Drink array
        var drinks = [Drink]()
        
        // Loop through months in year
        for month in year.data {
            drinks += self.filterDataByMonth(month: month)
        }
        
        // Return drinks
        return drinks
    }
    
    /**
     Get the total amount of `Drink`s consumed during the given `Year` and of this type
     - Parameter year: The `Year` to get the type amount for
     - Returns: The total amount of `Drink`s consumed during `year` and of this type
     */
    func getTypeAmountByYear(year: Year) -> Double {
        // Get the drinks for the given year and type
        let drinks = self.filterDataByYear(year: year)
        
        // Create amount and set to 0.0
        var amount = 0.0
        
        // Loop through drinks and add to amount
        for drink in drinks {
            amount += drink.amount
        }
        
        return amount
    }
    
    /**
     For a given `Year`, return `DataItem`s for each `Month` in that `Year` of this type
     - Parameter year: The `Year` to get `DataItem`s for
     - Returns: `DataItem`s for each `Month` in `Year` and of this type
     */
    func getDataItemsByYear(year: Year) -> [DataItem] {
        var dataItems = [DataItem]()
                
        // Loop through hour in dates
        for month in year.data {
            
            // Get the drinks based on the presense of the Total Type
            let drinks = self.filterDataByMonth(month: month)
            
            // Append the DataItem, using nil for drinks if drink array is empty
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: self, total: false, date: month.firstDay()))
        }
        
        return dataItems
    }
}

// MARK: - Equatable
extension DrinkType {
    
    /**
     Determines if two `DrinkType`s are the same
     - Parameters:
        - lhs: The `DrinkType` on the left of the `==`
        - rhs: The `DrinkType` on the right of the `==`
     - Returns: `true` if they're the same; `false` if not
     */
    static func == (lhs: DrinkType, rhs: DrinkType) -> Bool {
        if let colorL = lhs.color, let colorR = rhs.color {
            
            if let leftColor = UIColor.color(data: colorL), let rightColor = UIColor.color(data: colorR) {
                
                if lhs.name == rhs.name && lhs.isDefault == rhs.isDefault && lhs.enabled == rhs.enabled && lhs.colorChanged == rhs.colorChanged && leftColor == rightColor {
                    
                    return true
                    
                }
                
            }
            
        }
        
        return false
    }
}
