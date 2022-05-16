//
//  DMDataByMonthTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/2/22.
//

import XCTest
@testable import Liquidus

class DMDataByMonthTests: XCTestCase {

    var model: DrinkModel!
    
    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }

    func testGetMonth() {
        // Set expected Date array with each day of April 2022
        let expected = [
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 2))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 4))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 6))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 7))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 9))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 10))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 11))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 12))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 13))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 14))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 15))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 16))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 17))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 18))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 19))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 20))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 21))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 22))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 23))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 24))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 25))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 26))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 27))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 28))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 29))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 30))!
        ]
        
        // Get the method return
        let test = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!)
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertTrue(test[index].compare(expected[index]) == .orderedSame, "failed at index \(index)")
        }
    }

    func testFilerByMonth() {
        // Get the days in April 2022
        let testMonth = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Assert the method returns an empty array
        XCTAssertTrue(model.filterDataByMonth(month: testMonth).isEmpty)
        
        // Get the days in March 2022
        let lastMonth = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 1))!)
        
        // Add sample drinks for March 2022
        model.drinkData.drinks = SampleDrinks.month(lastMonth)
        
        // Assert the method returns an empty array
        XCTAssertTrue(model.filterDataByMonth(month: testMonth).isEmpty)

        // Add sample drinks for April 2022
        model.drinkData.drinks = SampleDrinks.month(testMonth)
        
        // Get the expected drinks for April 2022
        let expected = april2022AllDrinks()
        
        // Get the method return
        let test = model.filterDataByMonth(month: testMonth)
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(test[index], expected[index], "at index \(index)")
        }
    }
    
    func testFilterByMonthAndType() {
        // Get the days in April 2022
        let testMonth = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)

        // Assert the method returns an empty array
        XCTAssertTrue(model.filterDataByMonthAndType(type: model.drinkData.drinkTypes[0], month: testMonth).isEmpty)
        
        // Get the days in March 2022
        let lastMonth = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 1))!)

        // Add sample drinks for March 2022
        model.drinkData.drinks = SampleDrinks.month(lastMonth)

        // Assert the method returns an empty array
        XCTAssertTrue(model.filterDataByMonthAndType(type: model.drinkData.drinkTypes[0], month: testMonth).isEmpty)
        
        // Add sample drinks for April 2022
        model.drinkData.drinks = SampleDrinks.month(testMonth)
        
        // Get the expected drinks for April 2022
        let expected = april2022WaterDrinks()
        
        // Get the method return for Water
        let result1 = model.filterDataByMonthAndType(type: model.drinkData.drinkTypes[0], month: testMonth)
        
        // Assert at the same index the result1 and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result1[index], expected[index], "at index \(index)")
        }
        
        // Get the method return for Coffee
        let result2 = model.filterDataByMonthAndType(type: model.drinkData.drinkTypes[1], month: testMonth)

        // Assert at the same index the result2 and expected arrays don't return the same value
        for index in 0..<expected.count {
            XCTAssertNotEqual(result2[index], expected[index], "at index \(index)")
        }
    }
    
    func testGetTypeAmountByMonth() {
        // Get the days in April 2022
        let testMonth = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)

        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypeAmountByMonth(type: model.drinkData.drinkTypes[0], month: testMonth), 0.0)
        
        // Get the days in March 2022
        let lastMonth = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 1))!)
        
        // Add sample drinks for March 2022
        model.drinkData.drinks = SampleDrinks.month(lastMonth)

        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypeAmountByMonth(type: model.drinkData.drinkTypes[0], month: testMonth), 0.0)
        
        // Add sample drinks for April 2022
        model.drinkData.drinks = SampleDrinks.month(testMonth)
        
        // Set expected result
        let expected = 3200.0
        
        // Get the method return
        let result = model.getTypeAmountByMonth(type: model.drinkData.drinkTypes[0], month: testMonth)
        
        // Assert result and expected are the same value
        XCTAssertEqual(result, expected)
    }
    
    /**
     Returns an array with one drink per day in April 2022. Each drink has a set amount and date and cycle through the default drink types
     */
    private func april2022AllDrinks() -> [Drink] {
        return [
            Drink(type: model.drinkData.drinkTypes[0], amount: 50, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!),
            Drink(type: model.drinkData.drinkTypes[1], amount: 100, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 2))!),
            Drink(type: model.drinkData.drinkTypes[2], amount: 150, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!),
            Drink(type: model.drinkData.drinkTypes[3], amount: 200, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 4))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 250, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 5))!),
            Drink(type: model.drinkData.drinkTypes[1], amount: 300, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 6))!),
            Drink(type: model.drinkData.drinkTypes[2], amount: 350, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 7))!),
            Drink(type: model.drinkData.drinkTypes[3], amount: 400, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 450, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 9))!),
            Drink(type: model.drinkData.drinkTypes[1], amount: 500, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 10))!),
            Drink(type: model.drinkData.drinkTypes[2], amount: 550, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 11))!),
            Drink(type: model.drinkData.drinkTypes[3], amount: 600, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 12))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 650, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 13))!),
            Drink(type: model.drinkData.drinkTypes[1], amount: 700, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 14))!),
            Drink(type: model.drinkData.drinkTypes[2], amount: 750, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 15))!),
            Drink(type: model.drinkData.drinkTypes[3], amount: 800, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 16))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 750, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 17))!),
            Drink(type: model.drinkData.drinkTypes[1], amount: 700, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 18))!),
            Drink(type: model.drinkData.drinkTypes[2], amount: 650, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 19))!),
            Drink(type: model.drinkData.drinkTypes[3], amount: 600, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 20))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 550, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 21))!),
            Drink(type: model.drinkData.drinkTypes[1], amount: 500, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 22))!),
            Drink(type: model.drinkData.drinkTypes[2], amount: 450, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 23))!),
            Drink(type: model.drinkData.drinkTypes[3], amount: 400, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 24))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 350, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 25))!),
            Drink(type: model.drinkData.drinkTypes[1], amount: 300, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 26))!),
            Drink(type: model.drinkData.drinkTypes[2], amount: 250, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 27))!),
            Drink(type: model.drinkData.drinkTypes[3], amount: 200, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 28))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 150, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 29))!),
            Drink(type: model.drinkData.drinkTypes[1], amount: 100, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 30))!)
        ]
    }
    
    private func april2022WaterDrinks() -> [Drink] {
        return [
            Drink(type: model.drinkData.drinkTypes[0], amount: 50, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 250, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 5))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 450, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 9))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 650, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 13))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 750, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 17))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 550, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 21))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 350, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 25))!),
            Drink(type: model.drinkData.drinkTypes[0], amount: 150, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 29))!)
        ]
    }
}
