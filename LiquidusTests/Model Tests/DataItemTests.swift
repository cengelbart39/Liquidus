//
//  DataItemTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/16/22.
//

import XCTest
import CoreData
@testable import Liquidus

class DataItemTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    var water: DrinkType!
    
    var dataItem: DataItem!
    
    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
        
        self.water = SampleDrinkTypes.water(context)
        
        self.dataItem = DataItem(type: water, total: false, date: .now)
    }
    
    override func tearDown() {
        self.context = nil
        self.water = nil
        self.dataItem = nil
    }
    
    func testConstructor() {
        // Assert drinks array is nil
        XCTAssertNil(dataItem.drinks)
        
        // Assert the type of the data item is water
        XCTAssertEqual(dataItem.type, water)
        
        // Assert the description of the data item's date and the current date
        // are the same
        XCTAssertEqual(dataItem.date.description, Date.now.description)
    }
    
    func testGetMaxValue() {
        // Assert the max value is 0.0
        XCTAssertEqual(dataItem.getMaxValue(), 0.0)
        
        self.getWaterSampleDrinks()
        
        // Add Sample Drinks of Type Water
        dataItem.drinks = water.drinks?.allObjects as? [Drink]
        
        // Assert the max value is 500
        XCTAssertEqual(dataItem.getMaxValue(), 2500.0)
    }
    
    func testGetMinValue() {
        // Assert the max value is 0.0
        XCTAssertEqual(dataItem.getMinValue(), 0.0)
        
        self.getWaterSampleDrinks()
        
        // Add Sample Drinks of Type Water
        dataItem.drinks = water.drinks?.allObjects as? [Drink]
        
        // Assert the max value is 100
        XCTAssertEqual(dataItem.getMinValue(), 100.0)
    }
    
    func testGetIndividualAmount() {
        // Assert the individual amount is 0.0
        XCTAssertEqual(dataItem.getIndividualAmount(), 0.0)
        
        self.getWaterSampleDrinks()
        
        // Add Sample Drinks of Type Water
        dataItem.drinks = water.drinks?.allObjects as? [Drink]
        
        // Assert the individual amount is 2,500
        XCTAssertEqual(dataItem.getIndividualAmount(), 2500.0)
    }
    
    func testEqutable() {
        // Assert the data item is equal to itself
        XCTAssertEqual(dataItem, dataItem)
        
        let newDrink = Drink(context: context)
        newDrink.id = UUID()
        newDrink.type = self.water
        newDrink.amount = 500
        newDrink.date = Date.now
        
        self.water.addToDrinks(newDrink)
        
        // Create a dummy data item
        let newItem = DataItem(drinks: [newDrink], type: self.water, total: false, date: .now)
        
        // Assert the data items are not equal
        XCTAssertNotEqual(dataItem, newItem)
    }
    
    /**
     Generates an array of 9 Water `Drink`s
     - Returns: An array of 9 `Drink`s
     */
    func getWaterSampleDrinks() {
        let amounts: [Double] = [100, 200, 300, 400, 500, 400, 300, 200, 100]
        
        for amount in amounts {
            let drink = Drink(context: context)
            drink.id = UUID()
            drink.amount = amount
            drink.date = Date.now
            drink.type = self.water
            
            self.water.addToDrinks(drink)
        }
    }
}
