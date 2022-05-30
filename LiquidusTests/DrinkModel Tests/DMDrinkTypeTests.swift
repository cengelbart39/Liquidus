//
//  DMDrinkTypeTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/28/22.
//

import XCTest
import SwiftUI
@testable import Liquidus

class DMDrinkTypeTests: XCTestCase {

    var model: DrinkModel!
    
    // Set a custom type for Apple Cider
    private let customType = DrinkType(name: "Apple Cider", color: CodableColor(color: UIColor(red: 207/255, green: 58/255, blue: 31/255, alpha: 1)), isDefault: false, enabled: true, colorChanged: true)

    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }

    func testDeleteCustomDrinkTypes() {
        // Store expected types
        let expectedTypes = model.drinkData.drinkTypes
        
        // Create custom type
        let newType = customType
        
        // Save new Drink Type
        model.drinkData.drinkTypes.append(newType)
        
        // Generate week
        let week = Week()
        
        // Get sample drinks
        var sampleDrinks = SampleDrinks.week(week, type: newType)
        
        // Set data store
        model.drinkData.drinks = sampleDrinks
        
        // Remove Apple Cider drink and set to expected drinks
        sampleDrinks.remove(at: 4)
        let expectedDrinks = sampleDrinks

        // Offsets
        let offsets = IndexSet(integersIn: 4..<5)
        
        // Delete
        model.deleteCustomDrinks(atOffsets: offsets)
        
        // Assert the correct drinks are removed
        XCTAssertEqual(model.drinkData.drinks, expectedDrinks)
        
        // Assert the correct DrinkTypes are removed
        XCTAssertEqual(model.drinkData.drinkTypes, expectedTypes)
    }
    
    func testEditDrinkTypes() {
        // Append custom type
        model.drinkData.drinkTypes.append(customType)
        
        // Edit the name
        model.editDrinkType(old: customType, new: "Red Juice")
        
        // Set expectation
        let expected = customType
        expected.name = "Red Juice"
        
        // Assert Apple Cider's name is correctly changed
        XCTAssertEqual(model.drinkData.drinkTypes.last!, expected)
    }
    
    func testGetDrinkTypeColor() {
        // Assert that the default Water type returns .systemCyan
        XCTAssertEqual(model.drinkData.drinkTypes[0].color.getColor(), Color(.systemCyan))
        
        // Assert that the default Coffee type returns .systemBrown
        XCTAssertEqual(model.drinkData.drinkTypes[1].color.getColor(), Color(.systemBrown))
        
        // Assert that the default Soda type returns .systemGreen
        XCTAssertEqual(model.drinkData.drinkTypes[2].color.getColor(), Color(.systemGreen))
        
        // Assert that the default Juice type returns .systemOrange
        XCTAssertEqual(model.drinkData.drinkTypes[3].color.getColor(), Color(.systemOrange))
        
        // Assert that the Apple Cider custom type returns the stored color
        model.drinkData.drinkTypes.append(customType)
        XCTAssertEqual(model.drinkData.drinkTypes.last!.color.getColor(), customType.color.getColor())
    }
    
    func testFilterByDrinkType() {
        // Get the current week
        let week = Week()
        
        // Add sample drinks to drink store
        model.drinkData.drinks = SampleDrinks.week(week)
        
        // Get the filtered out drinks
        let result = model.filterByDrinkType(type: model.drinkData.drinkTypes.first!)
        
        // Get the expected drinks and remove the appropriate drinks
        var expected = SampleDrinks.week(week)
        expected.remove(at: 6)
        expected.remove(at: 5)
        expected.remove(at: 3)
        expected.remove(at: 2)
        expected.remove(at: 1)
        
        // Assert the first and second elements of result and expected
        // are the same
        XCTAssertEqual(result[0], expected[0])
        XCTAssertEqual(result[1], expected[1])
    }
    
    func testGetTypeAmount() {
        // Get current week
        let week = Week()
        
        // Add sample drinks to data store
        model.drinkData.drinks = SampleDrinks.week(week)
        
        // Get results
        let result = model.getTypeAmount(type: model.drinkData.drinkTypes.first!)
        
        // Assert that the result is 400.0
        XCTAssertEqual(result, 400.0)
    }
    
    func testGetTotalAmount() {
        // Add drinks
        model.drinkData.drinks = SampleDrinks.week(Week())
        
        // Test
        XCTAssertEqual(model.getTotalAmount(), 1600.0)
    }
    
    func testGetTypeAverageNil() {
        // Add the sample drinks
        model.drinkData.drinks = SampleDrinks.month(Month())
        
        // Get a date for April 1, 2022
        let currentDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!
        
        // Get the average
        let currentTest = model.getTypeAverage(type: model.drinkData.drinkTypes.first!, startDate: currentDate)
        
        // Assert that currentTest isn't nil
        XCTAssertNil(currentTest)
    }
    
    func testGetTypeAverageNonNil() {
        // Create dates for the first of Jan, Feb, Mar, Apr 2022
        let apr = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!
        let mar = Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 1))!
        let feb = Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 1))!
        let jan = Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 1))!
        
        // Get the dates for the whole months
        let april = Month(date: apr)
        let march = Month(date: mar)
        let february = Month(date: feb)
        let january = Month(date: jan)
        
        // Add sample drinks for all months
        model.drinkData.drinks = SampleDrinks.month(january) + SampleDrinks.month(february) + SampleDrinks.month(march) + SampleDrinks.month(april)
        
        // Test
        let test = model.getTypeAverage(type: model.drinkData.drinkTypes.first!, startDate: .now)
        
        // Assert test isn't nil
        XCTAssertNotNil(test)
        
        // Assert test returns 139
        XCTAssertEqual(test!, 139)
    }
    
    func testSaveDrinkType() {
        // Set expected drink type result
        let expected = model.drinkData.drinkTypes + [customType]
                
        // Save custom type to drink type store
        model.saveDrinkType(type: customType.name, color: customType.color.getColor())
        
        // Check results are equal
        XCTAssertEqual(model.drinkData.drinkTypes, expected)
    }
}
