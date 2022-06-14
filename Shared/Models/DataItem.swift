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
    
    /// The associated `DrinkType` with the `Drink`s; `nil` if `total` is `true`
    var type: DrinkType?
    
    /// Whether or not the `DataItem` contains `Drink`s from different `DrinkType`s; `true` if so
    var total: Bool
    
    /// The `Date` for the assoicated data
    var date: Date
    
    /**
     A description of a `DataItem`, taking in account all proprties except `id`
     */
    var description: String {
        if let drinks = drinks {
            if let type = type {
                return "DataItem(drinks: \(drinks), type: \(type), total: \(total), date: \(date.description)"
                
            } else {
                return "DataItem(drinks: \(drinks), type: nil, total: \(total), date: \(date.description)"
                
            }
        
        } else if let type = type {
            
            return "DataItem(drinks: nil, type: \(type), total: \(total),  date: \(date.description)"
        
        } else {
            
            return "DataItem(drinks: nil, type: nil, total: \(total),  date: \(date.description)"
            
        }
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
     Determines if two `DataItem`s are the same
     - Parameters:
        - lhs: The `DataItem` on the left of the `==`
        - rhs: The `DataItem` on the right of the `==`
     - Returns: `true` if they're the same; `false` if not
     */
    static func == (lhs: DataItem, rhs: DataItem) -> Bool {
        // Check if the type and dates are the same
        if lhs.total == rhs.total && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .year) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .month) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .day) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .hour) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .minute) == .orderedSame && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .second) == .orderedSame {
            
            if let lDrinks = lhs.drinks, let rDrinks = rhs.drinks {
                if let lT = lhs.type, let rT = rhs.type {
                    
                    for lD in lDrinks {
                        
                        var exists = false
                        
                        for rD in rDrinks {
                            if lD == rD { exists = true }
                        }
                        
                        if !exists { return false }
                        exists = false
                    }
                    
                    return lT == rT
                    
                } else {
                    
                    for lD in lDrinks {
                        
                        var exists = false
                        
                        for rD in rDrinks {
                            if lD == rD { exists = true }
                        }
                        
                        if !exists { return false }
                        exists = false
                    }
                    
                    return lhs.type == rhs.type
                }
            
            } else if let lT = lhs.type, let rT = rhs.type {
                
                if lT == rT && lhs.drinks == nil && rhs.drinks == nil {
                    return true
                }
            
            } else if lhs.drinks == nil && rhs.drinks == nil && lhs.type == nil && rhs.type == nil {
                
                return true
                
            }
        }
        
        // In all other cases return false
        return false
    }
}
