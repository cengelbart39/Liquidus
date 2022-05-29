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
        XCTAssertEqual(model.getProgressPercent(type: model.drinkData.drinkTypes[0], date: testDate), expected1)
        
        XCTAssertEqual(model.getProgressPercent(type: model.drinkData.drinkTypes[1], date: testDate), expected1)
        
        XCTAssertEqual(model.getProgressPercent(type: model.drinkData.drinkTypes[2], date: testDate), expected1)
        
        XCTAssertEqual(model.getProgressPercent(type: model.drinkData.drinkTypes[3], date: testDate), expected1)
    }

    func testGetHighlightColor() {
        // Get the week of April 8, 2022
        let testDate = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Set grayscale property to true
        model.grayscaleEnabled = true
        
        // Check the method returns Color.prinary
        XCTAssertEqual(model.getHighlightColor(type: model.drinkData.drinkTypes.first!, date: testDate), Color.primary)
        
        // Add a drink with an amount greater than the daily goal (2,000)
        model.drinkData.drinks.append(Drink(type: model.drinkData.drinkTypes.first!, amount: 2100, date: testDate.data))
        
        // Assert the method returns the "GoalGreen" color
        XCTAssertEqual(model.getHighlightColor(type: model.drinkData.drinkTypes.first!, date: testDate), Color("GoalGreen"))
    }
}
