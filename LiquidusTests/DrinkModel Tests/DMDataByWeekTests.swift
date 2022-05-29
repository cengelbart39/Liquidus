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
            Drink(type: model.drinkData.drinkTypes[0], amount: 100, date: testWeek.data[0].data),
            Drink(type: model.drinkData.drinkTypes[1], amount: 200, date: testWeek.data[1].data),
            Drink(type: model.drinkData.drinkTypes[2], amount: 300, date: testWeek.data[2].data),
            Drink(type: model.drinkData.drinkTypes[3], amount: 400, date: testWeek.data[3].data),
            Drink(type: model.drinkData.drinkTypes[0], amount: 300, date: testWeek.data[4].data),
            Drink(type: model.drinkData.drinkTypes[1], amount: 200, date: testWeek.data[5].data),
            Drink(type: model.drinkData.drinkTypes[2], amount: 100, date: testWeek.data[6].data)
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
            Drink(type: model.drinkData.drinkTypes[0], amount: 100, date: testWeek.data[0].data),
            Drink(type: model.drinkData.drinkTypes[0], amount: 300, date: testWeek.data[4].data)
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
    
    func testGetTypePercentByWeek() {
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypePercentByWeek(type: model.drinkData.drinkTypes[0], week: Week()), 0.0)
        
        // Add sample drinks on the day a week ago (i.e. if today is April 8, 2022, create a date for April 1, 2022)
        model.drinkData.drinks = SampleDrinks.week(Week(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!))

        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypePercentByWeek(type: model.drinkData.drinkTypes[0], week: Week()), 0.0)

        // Add sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(Week())

        // Get the week of April 8, 2022
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Add sample drinks for testWeek
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        // Set expected result
        let expected: Double = 400.0/14000.0
        
        // Assert the method returns the same value for each drink type
        XCTAssertEqual(model.getTypePercentByWeek(type: model.drinkData.drinkTypes[0], week: testWeek), expected)
        
        XCTAssertEqual(model.getTypePercentByWeek(type: model.drinkData.drinkTypes[1], week: testWeek), expected)

        XCTAssertEqual(model.getTypePercentByWeek(type: model.drinkData.drinkTypes[2], week: testWeek), expected)

        XCTAssertEqual(model.getTypePercentByWeek(type: model.drinkData.drinkTypes[3], week: testWeek), expected)
    }
    
    func testGetTotalAmountByWeek() {
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTotalAmountByWeek(week: Week()), 0.0)
        
        // Add sample drinks on the day a week ago (i.e. if today is April 8, 2022, create a date for April 1, 2022)
        model.drinkData.drinks = SampleDrinks.week(Week(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!))
        
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTotalAmountByWeek(week: Week()), 0.0)

        // Add sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(Week())

        // Get the week of April 8, 2022
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Add sample drinks for testWeek
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        // Assert the method returns 1600.0 for each drink type
        XCTAssertEqual(model.getTotalAmountByWeek(week: testWeek), 1600.0)
    }
    
    func testGetTotalPercentByWeek() {
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTotalPercentByWeek(week: Week()), 0.0)
        
        // Add sample drinks on the day a week ago (i.e. if today is April 8, 2022, create a date for April 1, 2022)
        model.drinkData.drinks = SampleDrinks.week(Week(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!))
        
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTotalPercentByWeek(week: Week()), 0.0)

        // Add sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(Week())

        // Get the week of April 8, 2022
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Add sample drinks for testWeek
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        // Set expected result
        let expected: Double = 1600.0/(7*2000.0)
        
        // Assert the method returns expected
        XCTAssertEqual(model.getTotalPercentByWeek(week: testWeek), expected)
    }
}
