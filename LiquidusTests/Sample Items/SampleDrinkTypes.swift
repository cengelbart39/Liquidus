//
//  SampleDrinkTypes.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 6/8/22.
//

import Foundation
import UIKit
import CoreData
@testable import Liquidus

/**
 A container class for static methods that return the 4 default `DrinkType`s and a custom `DrinkType`
 */
class SampleDrinkTypes {
    
    /**
     Get the Water `DrinkType` include by default in the main app
     - Parameter context: The view context created in the Unit Test to create the `DrinkType`
     - Returns: The Water `DrinkType`
     */
    static func water(_ context: NSManagedObjectContext) -> DrinkType {
        let water = DrinkType(context: context)
        water.id = UUID()
        water.name = "Water"
        water.order = 0
        water.enabled = true
        water.isDefault = true
        water.colorChanged = false
        water.color = UIColor.systemTeal.encode()
        water.drinks = nil
        
        return water
    }
    
    /**
     Get the Coffee `DrinkType` include by default in the main app
     - Parameter context: The view context created in the Unit Test to create the `DrinkType`
     - Returns: The Coffee `DrinkType`
     */
    static func coffee(_ context: NSManagedObjectContext) -> DrinkType {
        let coffee = DrinkType(context: context)
        coffee.id = UUID()
        coffee.name = "Coffee"
        coffee.order = 1
        coffee.enabled = true
        coffee.isDefault = true
        coffee.colorChanged = false
        coffee.color = UIColor.systemBrown.encode()
        coffee.drinks = nil
        
        return coffee
    }
    
    /**
     Get the Soda `DrinkType` include by default in the main app
     - Parameter context: The view context created in the Unit Test to create the `DrinkType`
     - Returns: The Soda `DrinkType`
     */
    static func soda(_ context: NSManagedObjectContext) -> DrinkType {
        let soda = DrinkType(context: context)
        soda.id = UUID()
        soda.name = "Soda"
        soda.order = 2
        soda.enabled = true
        soda.isDefault = true
        soda.colorChanged = false
        soda.color = UIColor.systemGreen.encode()
        soda.drinks = nil
        
        return soda
    }
    
    /**
     Get the Juice `DrinkType` include by default in the main app
     - Parameter context: The view context created in the Unit Test to create the `DrinkType`
     - Returns: The Juice `DrinkType`
     */
    static func juice(_ context: NSManagedObjectContext) -> DrinkType {
        let juice = DrinkType(context: context)
        juice.id = UUID()
        juice.name = "Juice"
        juice.order = 2
        juice.enabled = true
        juice.isDefault = true
        juice.colorChanged = false
        juice.color = UIColor.systemOrange.encode()
        juice.drinks = nil
        
        return juice
    }
    
    /**
     Get the Apple Cider `DrinkType` a custom type
     - Parameter context: The view context created in the Unit Test to create the `DrinkType`
     - Returns: The Apple Cider `DrinkType`
     */
    static func appleCider(_ context: NSManagedObjectContext) -> DrinkType {
        let appleCider = DrinkType(context: context)
        appleCider.id = UUID()
        appleCider.name = "Apple Cider"
        appleCider.order = 2
        appleCider.enabled = true
        appleCider.isDefault = true
        appleCider.colorChanged = false
        appleCider.color = UIColor(red: 207/255, green: 58/255, blue: 31/255, alpha: 1).encode()
        appleCider.drinks = nil
        
        return appleCider
    }
    
    /**
     Get the 4 Default `DrinkType`s: Water, Coffee, Soda, and Juice
     - Parameter context: The view context created in the Unit Test to create the `DrinkType`s
     - Returns: The 4 Default `DrinkType`s: Water, Coffee, Soda, and Juice
     */
    static func defaultTypes(_ context: NSManagedObjectContext) -> [DrinkType] {
        return [
            SampleDrinkTypes.water(context),
            SampleDrinkTypes.coffee(context),
            SampleDrinkTypes.soda(context),
            SampleDrinkTypes.juice(context)
        ]
    }
    
    /**
     Get the 4 Default `DrinkType`s (Water, Coffee, Soda, and Juice) and a custom Apple Cider `DrinkType`
     - Parameter context: The view context created in the Unit Test to create the `DrinkType`s
     - Returns: The 5 `DrinkType`s: Water, Coffee, Soda, Juice, and Apple Cider
     */
    static func allTypes(_ context: NSManagedObjectContext) -> [DrinkType] {
        
        return [
            SampleDrinkTypes.water(context),
            SampleDrinkTypes.coffee(context),
            SampleDrinkTypes.soda(context),
            SampleDrinkTypes.juice(context),
            SampleDrinkTypes.appleCider(context)
        ]
    }
}
