//
//  DataItem.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 1/24/22.
//

import Foundation

struct DataItem: Equatable, Identifiable {
    var id = UUID()
    var drinks: [Drink]?
    var type: DrinkType
    var date: Date
    
    /**
     For drinks (if they exist), in a DataItem, get the maximum value
     */
    func getMaxValue() -> Double {
        
        // Get drinks if they exist
        if let drinks = self.drinks {
            
            // Get the maximum value of the amount of each drink
            if let max = drinks.map({ $0.amount }).max() {
                return max
            }
        }
        
        return 0
    }
    
    /**
     For drinks (if they exist), in a DataItem, get the minimum value
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
     For a DataItem, get the total amount of all of its drinks (if they exist)
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
     For a DataItem array, get the total amount of all drinks (if they exist)
     */
    static func getTotalAmountByWeek(items: [DataItem]) -> Double {
        var total = 0.0
        
        // Loop through items
        for item in items {
            
            // Get drinks
            if let drinks = item.drinks {
                
                // Loop through drinks and add to total
                for drink in drinks {
                    total += drink.amount
                }
            }
        }
        
        return total
    }
    
    /**
     Generate a random array of DataItem
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
    
    static func == (lhs: DataItem, rhs: DataItem) -> Bool {
        if lhs.type == rhs.type && lhs.date == rhs.date {
            if let l = lhs.drinks, let r = rhs.drinks {
                for drink in l {
                    if !r.contains(drink) {
                        return false
                    }
                }
                return true
            } else if lhs.drinks == nil && rhs.drinks == nil {
                return true
            }
        }
        return false
    }
}
