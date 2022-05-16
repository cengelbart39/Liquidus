//
//  DMDataByHourTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/1/22.
//

import XCTest
@testable import Liquidus

class DMDataByHourTests: XCTestCase {

    var model: DrinkModel!
    
    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }

    func testFilterByHour() {
        // Get testHour
        let testHour = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: .now)!
        
        // Test that the function will return an empty array
        XCTAssertTrue(model.filterDataByHour(hour: testHour).isEmpty)
        
        // Add drinks for yesterday
        model.drinkData.drinks = SampleDrinks.day(Calendar.current.date(byAdding: .day, value: -1, to: .now)!)
        
        // Test that the function will return an empty array
        XCTAssertTrue(model.filterDataByHour(hour: testHour).isEmpty)
        
        // Add drinks for today
        model.drinkData.drinks = SampleDrinks.day(.now)
        
        // Create test drink
        let testDrink = Drink(type: model.drinkData.drinkTypes[0], amount: 600, date: testHour)
        
        // Set expected drink
        let expected1 = [testDrink]
        
        // Test that the drink filtered out is expected1
        XCTAssertEqual(model.filterDataByHour(hour: testHour), expected1)
        
        // Add another test drink to drink store
        model.drinkData.drinks.append(testDrink)
        
        // Set expected drinks
        let expected2 = [testDrink, testDrink]
        
        // Test that the drink filtered out is expected2
        XCTAssertEqual(model.filterDataByHour(hour: testHour), expected2)
    }
    
    func testFilterByHourAndType() {
        // Get testHour
        let testHour = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: .now)!
        
        // Test that the function will return an empty array
        XCTAssertTrue(model.filterDataByHourAndType(hour: testHour, type: model.drinkData.drinkTypes[0]).isEmpty)
        
        // Add drinks for yesterday
        model.drinkData.drinks = SampleDrinks.day(Calendar.current.date(byAdding: .day, value: -1, to: .now)!)
        
        // Test that the function will return an empty array
        XCTAssertTrue(model.filterDataByHourAndType(hour: testHour, type: model.drinkData.drinkTypes[0]).isEmpty)
        
        // Add drinks for today
        model.drinkData.drinks = SampleDrinks.day(.now)
        
        // Create test drink
        let testDrink = Drink(type: model.drinkData.drinkTypes[0], amount: 600, date: testHour)
        
        // Set expected drink
        let expected1 = [testDrink]

        // Test that the drink filtered out is expected1
        XCTAssertEqual(model.filterDataByHourAndType(hour: testHour, type: model.drinkData.drinkTypes[0]), expected1)
        
        // Test that the drink filtered out is NOT expected1
        XCTAssertNotEqual(model.filterDataByHourAndType(hour: testHour, type: model.drinkData.drinkTypes[1]), expected1)
        
        // Add another test drink to drink store
        model.drinkData.drinks.append(testDrink)
        
        // Set expected drinks
        let expected2 = [testDrink, testDrink]
        
        // Test that the drink filtered out is expected2
        XCTAssertEqual(model.filterDataByHourAndType(hour: testHour, type: model.drinkData.drinkTypes[0]), expected2)
        
        // Test that the drink filtered out is NOT expected2
        XCTAssertNotEqual(model.filterDataByHourAndType(hour: testHour, type: model.drinkData.drinkTypes[1]), expected2)
    }

    func testGetTypeAmountByHour() {
        // Get testHour
        let testHour = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: .now)!
        
        // Test that 0.0 is returned
        XCTAssertEqual(model.getTypeAmountByHour(type: model.drinkData.drinkTypes[0], time: testHour), 0.0)
        
        // Add drinks for last week
        model.drinkData.drinks = SampleDrinks.day(Calendar.current.date(byAdding: .day, value: -1, to: .now)!)
        
        // Test that 0.0 is returned
        XCTAssertEqual(model.getTypeAmountByHour(type: model.drinkData.drinkTypes[0], time: testHour), 0.0)
        
        // Add drinks for today
        model.drinkData.drinks = SampleDrinks.day(.now)
        
        // Create test drink
        let testDrink = Drink(type: model.drinkData.drinkTypes[0], amount: 600, date: testHour)
        
        // Test that the amount returned is 600.0
        XCTAssertEqual(model.getTypeAmountByHour(type: model.drinkData.drinkTypes[0], time: testHour), 600.0)
        
        // Test that the amount returned is 0.0
        XCTAssertEqual(model.getTypeAmountByHour(type: model.drinkData.drinkTypes[1], time: testHour), 0.0)
        
        model.drinkData.drinks.append(testDrink)
        
        // Test that the amount returned is 1200.0
        XCTAssertEqual(model.getTypeAmountByHour(type: model.drinkData.drinkTypes[0], time: testHour), 1200.0)
        
        // Test that the amount returned is 0.0
        XCTAssertEqual(model.getTypeAmountByHour(type: model.drinkData.drinkTypes[1], time: testHour), 0.0)
    }

}
