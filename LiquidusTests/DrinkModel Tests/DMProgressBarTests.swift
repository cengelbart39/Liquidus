//
//  DMProgressBarTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/3/22.
//

import XCTest
import SwiftUI
@testable import Liquidus

class DMProgressBarTests: XCTestCase {

    var model: DrinkModel!

    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }

    func testGetProgressPercent() {
        // Get the week of April 8, 2022
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Add sample drinks for that week
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        // Create a date for April 3, 2022
        let testDate = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!)
        
        // Set expected1 result
        let expected1 = 100.0/2000.0
        
        // Assert the method return is equal to expected1, regardless of type
        XCTAssertEqual(model.getProgressPercent(type: model.drinkData.drinkTypes[0], dates: testDate), expected1)
        
        XCTAssertEqual(model.getProgressPercent(type: model.drinkData.drinkTypes[1], dates: testDate), expected1)
        
        XCTAssertEqual(model.getProgressPercent(type: model.drinkData.drinkTypes[2], dates: testDate), expected1)
        
        XCTAssertEqual(model.getProgressPercent(type: model.drinkData.drinkTypes[3], dates: testDate), expected1)

        // Set expected2 result
        let expected2 = 400.0/(7*model.drinkData.dailyGoal)
        
        // Assert the return for Water is equal to expected2
        XCTAssertEqual(model.getProgressPercent(type: model.drinkData.drinkTypes[0], dates: testWeek), expected2)

        // Set expected3 result
        let expected3 = 2*expected2
        
        // Assert the return for Coffee is equal to expected3
        XCTAssertEqual(model.getProgressPercent(type: model.drinkData.drinkTypes[1], dates: testWeek), expected3)

        // Set expected4 result
        let expected4 = 3*expected2
        
        // Assert the return for Soda is equal to expected4
        XCTAssertEqual(model.getProgressPercent(type: model.drinkData.drinkTypes[2], dates: testWeek), expected4)
        
        // Set expected5 result
        let expected5 = 4*expected2
        
        // Assert the return for Juice is equal to expected5
        XCTAssertEqual(model.getProgressPercent(type: model.drinkData.drinkTypes[3], dates: testWeek), expected5)
    }

    func testGetHighlightColor() {
        // Get the week of April 8, 2022
        let testDate = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Set grayscale property to true
        model.grayscaleEnabled = true
        
        // Check the method returns Color.prinary
        XCTAssertEqual(model.getHighlightColor(type: model.drinkData.drinkTypes.first!, dates: testDate), Color.primary)
        
        // Add a drink with an amount greater than the daily goal (2,000)
        model.drinkData.drinks.append(Drink(type: model.drinkData.drinkTypes.first!, amount: 2100, date: testDate.data))
        
        // Assert the method returns the "GoalGreen" color
        XCTAssertEqual(model.getHighlightColor(type: model.drinkData.drinkTypes.first!, dates: testDate), Color("GoalGreen"))
        
        // Reset drink store and grayscale property
        model.drinkData.drinks = []
        model.grayscaleEnabled = false
        
        // Get the week of April 8, 2022
        let testWeek = Week(date: testDate.data)
        
        // Add sample drinks for that week
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        // Assert the color returned for Water is .systemCyan
        XCTAssertEqual(model.getHighlightColor(type: model.drinkData.drinkTypes[0], dates: testWeek), Color(.systemCyan))
        
        // Assert the color returned for Coffee is .systemBrown
        XCTAssertEqual(model.getHighlightColor(type: model.drinkData.drinkTypes[1], dates: testWeek), Color(.systemBrown))
        
        // Assert the color returned for Soda is .systemGreen
        XCTAssertEqual(model.getHighlightColor(type: model.drinkData.drinkTypes[2], dates: testWeek), Color(.systemGreen))

        // Assert the color returned for Juice is .systemOrange
        XCTAssertEqual(model.getHighlightColor(type: model.drinkData.drinkTypes[3], dates: testWeek), Color(.systemOrange))
        
        // Add a drink with an amount greater than the daily goal (2,000)
        model.drinkData.drinks.append(Drink(type: model.drinkData.drinkTypes.first!, amount: 2100, date: testDate.data))

        // Assert the color returned for Water is "GoalGreen"
        XCTAssertEqual(model.getHighlightColor(type: model.drinkData.drinkTypes[0], dates: testDate), Color("GoalGreen"))

        // Assert the color returned for Coffee is .systemBrown
        XCTAssertEqual(model.getHighlightColor(type: model.drinkData.drinkTypes[1], dates: testWeek), Color(.systemBrown))
        
        // Assert the color returned for Soda is .systemGreen
        XCTAssertEqual(model.getHighlightColor(type: model.drinkData.drinkTypes[2], dates: testWeek), Color(.systemGreen))

        // Assert the color returned for Juice is .systemOrange
        XCTAssertEqual(model.getHighlightColor(type: model.drinkData.drinkTypes[3], dates: testWeek), Color(.systemOrange))
        
    }
}
