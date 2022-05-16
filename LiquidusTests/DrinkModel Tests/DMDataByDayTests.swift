//
//  DMDataByDayTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/30/22.
//

import XCTest
@testable import Liquidus

class DMDataByDayTests: XCTestCase {

    var model: DrinkModel!
    
    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }

    func testFilterByDay() {
        // Test that the function will return an empty array
        XCTAssertTrue(model.filterDataByDay(day: .now).isEmpty)
        
        // Add drinks for last week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: Calendar.current.date(byAdding: .day, value: -7, to: .now)!))
        
        // Test that the function will return an empty array
        XCTAssertTrue(model.filterDataByDay(day: .now).isEmpty)

        // Create test date
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!

        // Add drinks for today
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: testDate))
        
        // Create test drink
        let testDrink = Drink(type: model.drinkData.drinkTypes[1], amount: 200, date: testDate)
        
        // Set expected drink
        let expected1 = [testDrink]
        
        // Test that the drink filtered out is expected1
        XCTAssertEqual(model.filterDataByDay(day: testDate), expected1)
        
        // Add testDrink to drink store
        model.drinkData.drinks.append(testDrink)
        
        // Set expected drinks
        let expected2 = [testDrink, testDrink]
        
        // Test that the drinks filtered out is expected2
        XCTAssertEqual(model.filterDataByDay(day: testDate), expected2)
    }
    
    func testFilterByDayAndType() {
        // Test that the function will return an empty array
        XCTAssertTrue(model.filterDataByDayAndType(type: model.drinkData.drinkTypes[0], day: .now).isEmpty)
        
        // Add drinks for last week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!))
        
        // Test that the function will return an empty array
        XCTAssertTrue(model.filterDataByDayAndType(type: model.drinkData.drinkTypes[0], day: .now).isEmpty)

        // Create test date
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!

        // Add drinks for today
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: testDate))
        
        // Create test drink
        let testDrink = Drink(type: model.drinkData.drinkTypes[1], amount: 200, date: testDate)
        
        // Set expected drink
        let expected1 = [testDrink]
        
        // Test that the drink filtered out is expected1
        XCTAssertEqual(model.filterDataByDayAndType(type: model.drinkData.drinkTypes[1], day: testDate), expected1)
        
        // Test that that an empty array is returned
        XCTAssertEqual(model.filterDataByDayAndType(type: model.drinkData.drinkTypes[0], day: testDate), [])
        
        // Add testDrink to drink store
        model.drinkData.drinks.append(testDrink)
        
        // Set expected drinks
        let expected2 = [testDrink, testDrink]
        
        // Test that the drink filtered out is expected2
        XCTAssertEqual(model.filterDataByDayAndType(type: model.drinkData.drinkTypes[1], day: testDate), expected2)
        
        // Test that that an empty array is returned
        XCTAssertEqual(model.filterDataByDayAndType(type: model.drinkData.drinkTypes[0], day: testDate), [])
    }
        
    func testGetTypeAmountByDay() {
        // Create a date for April 8, 2022
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Test that 0.0 is returned when there are no drinks in store
        XCTAssertEqual(model.getTypeAmountByDay(type: model.drinkData.drinkTypes[0], date: .now), 0.0)
        
        // Add drinks for last week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!))
        
        // Test that 0.0 is returned when there are drinks that are not from today
        XCTAssertEqual(model.getTypeAmountByDay(type: model.drinkData.drinkTypes[0], date: .now), 0.0)

        // Add drinks for testDate
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: testDate))
        
        // Create test drink
        let testDrink = Drink(type: model.drinkData.drinkTypes[1], amount: 200, date: testDate)
        
        // Test that the amount returned is 200.0
        XCTAssertEqual(model.getTypeAmountByDay(type: model.drinkData.drinkTypes[1], date: testDate), 200.0)
        
        // Test that the amount returned is NOT 200.0
        XCTAssertNotEqual(model.getTypeAmountByDay(type: model.drinkData.drinkTypes[0], date: testDate), 200.0)

        // Append testDrink to drink store
        model.drinkData.drinks.append(testDrink)
        
        // Test that the amount returned is 400.0
        XCTAssertEqual(model.getTypeAmountByDay(type: model.drinkData.drinkTypes[1], date: testDate), 400.0)
        
        // Test that the amount returned is NOT 400.0
        XCTAssertNotEqual(model.getTypeAmountByDay(type: model.drinkData.drinkTypes[0], date: testDate), 400.0)
    }
    
    func testGetTypePercentByDay() {
        // Create a date for April 8, 2022
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Test that 0.0 is returned when there are no drinks in store
        XCTAssertEqual(model.getTypePercentByDay(type: model.drinkData.drinkTypes[0], date: .now), 0.0)
        
        // Add drinks for last week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!))
        
        // Test that 0.0 is returned when there are drinks that are not from today
        XCTAssertEqual(model.getTypePercentByDay(type: model.drinkData.drinkTypes[0], date: .now), 0.0)
        
        // Add drinks for testDate
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: testDate))
        
        // Create test drink
        let testDrink = Drink(type: model.drinkData.drinkTypes[1], amount: 200, date: testDate)
        
        // Get expected percent 1
        let expected1: Double = 200/2000
        
        // Test that the amount returned is expected1
        XCTAssertEqual(model.getTypePercentByDay(type: model.drinkData.drinkTypes[1], date: testDate), expected1)
        
        // Test that the amount returned is 0.0
        XCTAssertEqual(model.getTypePercentByDay(type: model.drinkData.drinkTypes[0], date: testDate), 0.0)

        // Append test drink to drink store
        model.drinkData.drinks.append(testDrink)
        
        // Get expected percent 2
        let expected2: Double = 400/2000
        
        // Test that the amount returned is expected2
        XCTAssertEqual(model.getTypePercentByDay(type: model.drinkData.drinkTypes[1], date: testDate), expected2)

        // Test that the amount returned is 0.0
        XCTAssertEqual(model.getTypePercentByDay(type: model.drinkData.drinkTypes[0], date: testDate), 0.0)
    }
    
    func testGetTotalAmountByDay() {
        // Create a date for April 8, 2022
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Test that 0.0 is returned when there are no drinks in store
        XCTAssertEqual(model.getTotalAmountByDay(date: .now), 0.0)
        
        // Add drinks for last week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: Calendar.current.date(byAdding: .day, value: -7, to: .now)!))
        
        // Test that 0.0 is returned when there are drinks that are not from today
        XCTAssertEqual(model.getTotalAmountByDay(date: .now), 0.0)
        
        // Add drinks for testDate
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: testDate))
        
        // Create date for every day of the week
        let sun = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!
        let mon = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 4))!
        let tue = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 5))!
        let wed = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 6))!
        let thu = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 7))!
        let fri = testDate
        let sat = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 9))!
        
        // Check the amount for each day
        XCTAssertEqual(model.getTotalAmountByDay(date: sun), 100)
        XCTAssertEqual(model.getTotalAmountByDay(date: mon), 200)
        XCTAssertEqual(model.getTotalAmountByDay(date: tue), 300)
        XCTAssertEqual(model.getTotalAmountByDay(date: wed), 400)
        XCTAssertEqual(model.getTotalAmountByDay(date: thu), 300)
        XCTAssertEqual(model.getTotalAmountByDay(date: fri), 200)
        XCTAssertEqual(model.getTotalAmountByDay(date: sat), 100)
    }
}
