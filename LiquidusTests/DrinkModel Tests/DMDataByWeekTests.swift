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

    func testGetWeekRange() {
        // Create a date for April 8, 2022
        let testDate1 = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Create a date for April 9, 2022
        let testDate2 = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 9))!
        
        // Create a date for April 3, 2022
        let testDate3 = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!

        // Set expected result
        let expected = [
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 9))!
        ]

        // Assert the results for each testDate is the expected result
        XCTAssertEqual(model.getWeekRange(date: testDate1).description, expected.description)
        
        XCTAssertEqual(model.getWeekRange(date: testDate2).description, expected.description)
        
        XCTAssertEqual(model.getWeekRange(date: testDate3).description, expected.description)
        
    }

    func testGetWeek() {
        // Create a date for April 8, 2022
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Create the expected array of dates
        let expected = [
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 4))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 6))!,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 7))!,
            testDate,
            Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 9))!
        ]
        
        // Assert the fetched week is the same as the expected week
        XCTAssertEqual(model.getWeek(date: testDate).description, expected.description)

    }
    
    func testFilterByWeek() {
        // Assert that the method returns an empty array
        XCTAssertTrue(model.filterDataByWeek(week: model.getWeek(date: .now)).isEmpty)
        
        // Add sample drinks on the day a week ago (i.e. if today is April 8, 2022, create a date for April 1, 2022)
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!))
        
        // Assert that the method returns an empty array
        XCTAssertTrue(model.filterDataByWeek(week: model.getWeek(date: .now)).isEmpty)

        // Add sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: .now))

        // Get the week of April 8, 2022
        let testWeek = model.getWeek(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Add sample drinks for testWeek
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        // Get the function return
        let result = model.filterDataByWeek(week: testWeek)
        
        // Set the expected drink array
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: 100, date: testWeek[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: 200, date: testWeek[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: 300, date: testWeek[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: 400, date: testWeek[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: 300, date: testWeek[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: 200, date: testWeek[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: 100, date: testWeek[6])
        ]
        
        // Assert each index of the expected and result arrays are equal
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "expected \(expected[index]) but got \(result[index]); failed at index \(index)")
        }
    }
    
    func testFilterByWeekAndType() {
        // Assert the method returns an empty array
        XCTAssertTrue(model.filterDataByWeekAndType(type: model.drinkData.drinkTypes[0], week: model.getWeek(date: .now)).isEmpty)
        
        // Add sample drinks on the day a week ago (i.e. if today is April 8, 2022, create a date for April 1, 2022)
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!))
        
        // Assert the method returns an empty array
        XCTAssertTrue(model.filterDataByWeekAndType(type: model.drinkData.drinkTypes[0], week: model.getWeek(date: .now)).isEmpty)

        // Add sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: .now))

        // Get the week of April 8, 2022
        let testWeek = model.getWeek(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Add sample drinks for testWeek
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        let result1 = model.filterDataByWeekAndType(type: model.drinkData.drinkTypes[0], week: testWeek)
        
        let result2 = model.filterDataByWeekAndType(type: model.drinkData.drinkTypes[1], week: testWeek)
        
        // Set the expected drink array
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: 100, date: testWeek[0]),
            Drink(type: model.drinkData.drinkTypes[0], amount: 300, date: testWeek[4])
        ]
        
        // Assert result1 is equal to the expected array
        XCTAssertEqual(result1, expected)
        
        // Assert result2 is not equal tot he expected array
        XCTAssertNotEqual(result2, expected)
    }
    
    func testGetTypeAmountByWeek() {
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypeAmountByWeek(type: model.drinkData.drinkTypes[0], week: model.getWeek(date: .now)), 0.0)
        
        // Add sample drinks on the day a week ago (i.e. if today is April 8, 2022, create a date for April 1, 2022)
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!))
        
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypeAmountByWeek(type: model.drinkData.drinkTypes[0], week: model.getWeek(date: .now)), 0.0)
        
        // Add sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: .now))

        // Get the week of April 8, 2022
        let testWeek = model.getWeek(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
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
        XCTAssertEqual(model.getTypePercentByWeek(type: model.drinkData.drinkTypes[0], week: model.getWeek(date: .now)), 0.0)
        
        // Add sample drinks on the day a week ago (i.e. if today is April 8, 2022, create a date for April 1, 2022)
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!))

        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypePercentByWeek(type: model.drinkData.drinkTypes[0], week: model.getWeek(date: .now)), 0.0)

        // Add sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: .now))

        // Get the week of April 8, 2022
        let testWeek = model.getWeek(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
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
        XCTAssertEqual(model.getTotalAmountByWeek(week: model.getWeek(date: .now)), 0.0)
        
        // Add sample drinks on the day a week ago (i.e. if today is April 8, 2022, create a date for April 1, 2022)
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!))
        
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTotalAmountByWeek(week: model.getWeek(date: .now)), 0.0)

        // Add sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: .now))

        // Get the week of April 8, 2022
        let testWeek = model.getWeek(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Add sample drinks for testWeek
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        // Assert the method returns 1600.0 for each drink type
        XCTAssertEqual(model.getTotalAmountByWeek(week: testWeek), 1600.0)
    }
    
    func testGetTotalPercentByWeek() {
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTotalPercentByWeek(week: model.getWeek(date: .now)), 0.0)
        
        // Add sample drinks on the day a week ago (i.e. if today is April 8, 2022, create a date for April 1, 2022)
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!))
        
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTotalPercentByWeek(week: model.getWeek(date: .now)), 0.0)

        // Add sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: .now))

        // Get the week of April 8, 2022
        let testWeek = model.getWeek(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Add sample drinks for testWeek
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        // Set expected result
        let expected: Double = 1600.0/(7*2000.0)
        
        // Assert the method returns expected
        XCTAssertEqual(model.getTotalPercentByWeek(week: testWeek), expected)
    }

    func testDoesDateFallInSameWeek() {
        // Set dates
        let testDate1 = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        let testDate2 = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!

        // Assert the current date and testDate1 do not fall in the same week
        XCTAssertFalse(model.doesDateFallInSameWeek(date1: testDate1, date2: .now))
        
        // Assert the testDates fall in the same week
        XCTAssertTrue(model.doesDateFallInSameWeek(date1: testDate1, date2: testDate2))
    }
}
