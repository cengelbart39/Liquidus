//
//  DMDataByWeekTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/1/22.
//

import XCTest
@testable import Liquidus

class DMDataByWeekTests: XCTestCase {

    var model: DrinkModel!
    
    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }
    
    func testFilterByWeek() {
        // Assert that the method returns an empty array
        XCTAssertTrue(model.filterDataByWeek(week: Week()).isEmpty)
        
        // Add sample drinks on the day a week ago (i.e. if today is April 8, 2022, create a date for April 1, 2022)
        model.drinkData.drinks = SampleDrinks.week(Week(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!))
        
        // Assert that the method returns an empty array
        XCTAssertTrue(model.filterDataByWeek(week: Week()).isEmpty)

        // Add sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(Week())

        // Get the week of April 8, 2022
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Add sample drinks for testWeek
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        // Get the function return
        let result = model.filterDataByWeek(week: testWeek)
        
        // Set the expected drink array
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: 100, date: testWeek.data[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: 200, date: testWeek.data[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: 300, date: testWeek.data[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: 400, date: testWeek.data[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: 300, date: testWeek.data[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: 200, date: testWeek.data[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: 100, date: testWeek.data[6])
        ]
        
        // Assert each index of the expected and result arrays are equal
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "expected \(expected[index]) but got \(result[index]); failed at index \(index)")
        }
    }
    
    func testFilterByWeekAndType() {
        // Assert the method returns an empty array
        XCTAssertTrue(model.filterDataByWeekAndType(type: model.drinkData.drinkTypes[0], week: Week()).isEmpty)
        
        // Add sample drinks on the day a week ago (i.e. if today is April 8, 2022, create a date for April 1, 2022)
        model.drinkData.drinks = SampleDrinks.week(Week(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!))
        
        // Assert the method returns an empty array
        XCTAssertTrue(model.filterDataByWeekAndType(type: model.drinkData.drinkTypes[0], week: Week()).isEmpty)

        // Add sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(Week())

        // Get the week of April 8, 2022
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Add sample drinks for testWeek
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        let result1 = model.filterDataByWeekAndType(type: model.drinkData.drinkTypes[0], week: testWeek)
        
        let result2 = model.filterDataByWeekAndType(type: model.drinkData.drinkTypes[1], week: testWeek)
        
        // Set the expected drink array
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: 100, date: testWeek.data[0]),
            Drink(type: model.drinkData.drinkTypes[0], amount: 300, date: testWeek.data[4])
        ]
        
        // Assert result1 is equal to the expected array
        XCTAssertEqual(result1, expected)
        
        // Assert result2 is not equal tot he expected array
        XCTAssertNotEqual(result2, expected)
    }
    
    func testGetTypeAmountByWeek() {
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypeAmountByWeek(type: model.drinkData.drinkTypes[0], week: Week()), 0.0)
        
        // Add sample drinks on the day a week ago (i.e. if today is April 8, 2022, create a date for April 1, 2022)
        model.drinkData.drinks = SampleDrinks.week(Week(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!))
        
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypeAmountByWeek(type: model.drinkData.drinkTypes[0], week: Week()), 0.0)
        
        // Add sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(Week())

        // Get the week of April 8, 2022
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Add sample drinks for testWeek
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        // Assert the method returns 400.0 for each drink type
        XCTAssertEqual(model.getTypeAmountByWeek(type: model.drinkData.drinkTypes[0], week: testWeek), 400.0)
        
        XCTAssertEqual(model.getTypeAmountByWeek(type: model.drinkData.drinkTypes[1], week: testWeek), 400.0)
        
        XCTAssertEqual(model.getTypeAmountByWeek(type: model.drinkData.drinkTypes[2], week: testWeek), 400.0)
        
        XCTAssertEqual(model.getTypeAmountByWeek(type: model.drinkData.drinkTypes[3], week: testWeek), 400.0)
    }    
}
