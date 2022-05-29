//
//  DataItemTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/16/22.
//

import XCTest
@testable import Liquidus

class DataItemTests: XCTestCase {
    
    let water = DrinkType.getWater()
    
    var dataItem: DataItem!
    
    override func setUp() {
        self.dataItem = DataItem(type: water, date: .now)
    }
    
    override func tearDown() {
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
        
        // Add Sample Drinks of Type Water
        dataItem.drinks = Drink.getWaterSampleDrinks()
        
        // Assert the max value is 500
        XCTAssertEqual(dataItem.getMaxValue(), 2500.0)
    }
    
    func testGetMinValue() {
        // Assert the max value is 0.0
        XCTAssertEqual(dataItem.getMinValue(), 0.0)
        
        // Add Sample Drinks of Type Water
        dataItem.drinks = Drink.getWaterSampleDrinks()
        
        // Assert the max value is 100
        XCTAssertEqual(dataItem.getMinValue(), 100.0)
    }
    
    func testGetIndividualAmount() {
        // Assert the individual amount is 0.0
        XCTAssertEqual(dataItem.getIndividualAmount(), 0.0)
        
        // Add Sample Drinks of Type Water
        dataItem.drinks = Drink.getWaterSampleDrinks()
        
        // Assert the individual amount is 2,500
        XCTAssertEqual(dataItem.getIndividualAmount(), 2500.0)
    }
    
    func testEqutable() {
        // Assert the data item is equal to itself
        XCTAssertEqual(dataItem, dataItem)
        
        // Create a dummy data item
        let newItem = DataItem(drinks: [Drink(type: DrinkType.getWater(), amount: 500, date: .now)], type: DrinkType.getWater(), date: .now)
        
        // Assert the data items are not equal
        XCTAssertNotEqual(dataItem, newItem)
    }
}
