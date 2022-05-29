//
//  DataItem.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 1/24/22.
//

import Foundation

/**
 A `struct` representing data used in `TrendsChartView`
 */
struct DataItem: CustomStringConvertible, Equatable, Identifiable {
    
    /// The unique id of the `DataItem`
    var id = UUID()
    
    /// The `Drink`s consumed during `date`; `nil` if no `Drink`s have been consumed
    var drinks: [Drink]?
    
    /// The associated `DrinkType` with the `Drink`s
    var type: DrinkType
    
    /// The `Date` for the assoicated data
    var date: Date
    
    /**
     A description of a `DataItem`, taking in account all proprties except `id`
     */
    var description: String {
        if let drinks = drinks {
            return "DataItem(drinks: \(drinks), type: \(type), date: \(date.description)"
        }
        
        return "DataItem(drinks: nil, type: \(type), date: \(date.description)"
    }
    
    /**
     For `Drink`s (if they exist), in a `DataItem`, get the maximum value
     - Returns: The maximum value
     */
    func getMaxValue() -> Double {
        
        // Get drinks if they exist
        if let drinks = self.drinks {
            
            var amount = 0.0
            
            // Get the maximum value of the amount of each drink
            for drink in drinks {
                amount += drink.amount
            }
            
            return amount
        }
        
        return 0
    }
    
    /**
     For `Drink`s (if they exist), in a `DataItem`, get the minimum value
     - Returns: The minimum value
     */
    func getMinValue() -> Double {
        
        // Get drinks if they exist
        if let drinks = self.drinks {
            
            // Get the minimum value of the amount of each drink
            if let min = drinks.map({ $0.amount }).min() {
                return min
            }
        }
        
        return 0.0
    }
    
    /**
     For a `DataItem`, get the total amount of all of its `Drink`s (if they exist)
     - Returns: The total amount of `Drink`s in the `DrinkType` (0 if they don't exist)
     */
    func getIndividualAmount() -> Double {
        var total = 0.0
        
        // Get drinks if they exist
        if let drinks = self.drinks {
            
            // Loop through all drinks and get total amount
            for drink in drinks {
                total += drink.amount
            }
        }
        
        return total
    }
    /**
     Generate a random array of `DataItem`
     - Returns: A random `[DataItem]` array
     */
    static func dailySampleData() -> [DataItem] {
        var dates = [Date]()
        
        for index in 0...23 {
            dates.append(Calendar.current.date(bySettingHour: index, minute: 0, second: 0, of: .now)!)
        }
        
        var drinks = [Drink]()
        
        let water = DrinkType(name: Constants.waterKey, color: CodableColor(color: .systemCyan), isDefault: true, enabled: true, colorChanged: false)
        
        for date in dates {
            drinks.append(Drink(type: water, amount: Double(Int.random(in: 250...1500)), date: date))
        }
        
        var dataItems = [DataItem]()
        
        for index in 0...23 {
            dataItems.append(DataItem(drinks: [drinks[index]], type: water, date: dates[index]))
        }
        
        return dataItems
    }
    
    /**
     Determines if two `DataItem`s are the same
     - Parameters:
        - lhs: The `DataItem` on the left of the `==`
        - rhs: The `DataItem` on the right of the `==`
     - Returns: `true` if they're the same; `false` if not
     */
    static func == (lhs: DataItem, rhs: DataItem) -> Bool {
        // Check if the type and dates are the same
        if lhs.type == rhs.type && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .year) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .month) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .day) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .hour) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .minute) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .second) == .orderedSame {
            
            // Checl if drinks exists for both
            if let l = lhs.drinks, let r = rhs.drinks {
                
                // Checks if any drink are exclusive
                for drink in l {
                    
                    // If so returns false
                    if !r.contains(drink) {
                        return false
                    }
                }
                
                // If not return true
                return true
                
            // If both drinks array are nil return true
            } else if lhs.drinks == nil && rhs.drinks == nil {
                return true
                
            }
        }
        
        // In all other cases return false
        return false
    }
}
